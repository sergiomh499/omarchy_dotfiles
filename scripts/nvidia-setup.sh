#!/usr/bin/env bash
# Install NVIDIA proprietary driver (open kernel module) for CachyOS + Hyprland PRIME offload.
# Usage: sudo bash ~/nvidia-setup.sh
# Safe to re-run.

set -euo pipefail

echo "=== [1/5] Installing NVIDIA packages ==="
pacman -S --noconfirm --needed \
  linux-cachyos-nvidia-open \
  nvidia-utils \
  nvidia-settings \
  libva-nvidia-driver
echo "OK"

echo ""
echo "=== [2/5] Configuring mkinitcpio ==="
MKINIT_CONF=/etc/mkinitcpio.conf.d/nvidia.conf

cat > "$MKINIT_CONF" <<'EOF'
# Load NVIDIA modules early for DRM modesetting (PRIME offload / Wayland)
MODULES+=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)
EOF

# Remove 'kms' from HOOKS in the base config — it conflicts with nvidia early modesetting.
# We do this by dropping it via a conf.d drop-in (override approach, non-destructive).
if grep -q '\bkms\b' /etc/mkinitcpio.conf; then
  # Patch the main config directly (CachyOS ships a single-file config)
  cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.bak-$(date +%Y%m%d)
  sed -i 's/\bkms\b //' /etc/mkinitcpio.conf
  echo "  removed 'kms' from HOOKS (backup saved)"
fi

echo "OK: $MKINIT_CONF written"

echo ""
echo "=== [3/5] Adding kernel parameters (Limine) ==="
# Find limine.conf — CachyOS puts it on the EFI partition
LIMINE_CONF=""
for candidate in \
  /boot/limine.conf \
  /efi/limine.conf \
  /boot/efi/limine.conf \
  /efi/EFI/limine/limine.conf \
  /boot/EFI/limine/limine.conf; do
  if [[ -f "$candidate" ]]; then
    LIMINE_CONF="$candidate"
    break
  fi
done

if [[ -z "$LIMINE_CONF" ]]; then
  # Try mounting EFI partition if not already mounted
  EFI_DEV=$(lsblk -npo NAME,PARTTYPE | awk '/c12a7328-f81f-11d2-ba4b-00a0c93ec93b/{print $1}' | head -1)
  if [[ -n "$EFI_DEV" ]]; then
    mount "$EFI_DEV" /efi 2>/dev/null || true
    for candidate in /efi/limine.conf /efi/EFI/limine/limine.conf; do
      [[ -f "$candidate" ]] && LIMINE_CONF="$candidate" && break
    done
  fi
fi

if [[ -z "$LIMINE_CONF" ]]; then
  echo "  WARNING: Could not find limine.conf — add these kernel params manually:"
  echo "  nvidia_drm.modeset=1 nvidia_drm.fbdev=1"
else
  cp "$LIMINE_CONF" "${LIMINE_CONF}.bak-$(date +%Y%m%d)"
  # Add params to every kernel= line that doesn't already have them
  sed -i '/^[[:space:]]*kernel_cmdline[[:space:]]*=/{
    /nvidia_drm\.modeset/! s/$/ nvidia_drm.modeset=1 nvidia_drm.fbdev=1/
  }' "$LIMINE_CONF"
  # Also handle 'cmdline' key variant
  sed -i '/^[[:space:]]*cmdline[[:space:]]*=/{
    /nvidia_drm\.modeset/! s/$/ nvidia_drm.modeset=1 nvidia_drm.fbdev=1/
  }' "$LIMINE_CONF"
  echo "OK: patched $LIMINE_CONF"
fi

echo ""
echo "=== [4/5] Blacklisting nouveau ==="
cat > /etc/modprobe.d/nvidia-blacklist.conf <<'EOF'
blacklist nouveau
options nouveau modeset=0
# D3cold: fully power off dGPU when idle (battery safe, wakes on prime-run demand)
options nvidia NVreg_DynamicPowerManagement=0x02
EOF
echo "OK"

echo ""
echo "=== [5/5] Rebuilding initramfs ==="
mkinitcpio -P
echo "OK"

echo ""
echo "============================================"
echo "Done. REBOOT required to activate the driver."
echo "After reboot verify with: nvidia-smi"
echo "============================================"
