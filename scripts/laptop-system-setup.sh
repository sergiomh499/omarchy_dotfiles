#!/usr/bin/env bash
# Run once as root to apply system-level laptop improvements.
# Usage: sudo bash ~/laptop-system-setup.sh

set -euo pipefail

echo "=== [1/3] Enabling irqbalance ==="
if ! pacman -Qi irqbalance &>/dev/null; then
  echo "  installing irqbalance..."
  pacman -S --noconfirm irqbalance
fi
systemctl enable --now irqbalance
echo "OK: irqbalance active ($(systemctl is-active irqbalance))"

echo ""
echo "=== [2/3] Setting vm.swappiness=180 for zram-first behaviour ==="
SYSCTL_FILE=/etc/sysctl.d/99-laptop-tuning.conf
cat > "$SYSCTL_FILE" <<'EOF'
# Prefer zram over disk swap (zram is at priority 100; disk swapfile at 0)
# Value >100 tips the kernel to strongly prefer zram compression over paging to disk.
vm.swappiness = 180
EOF
sysctl --system --pattern "vm.swappiness" | tail -1
echo "OK: written to $SYSCTL_FILE"

echo ""
echo "=== [3/3] Updating BTRFS compression to zstd:3 in /etc/fstab ==="
cp /etc/fstab /etc/fstab.bak-$(date +%Y%m%d)
sed -i 's/compress=zstd:1/compress=zstd:3/g' /etc/fstab
echo "OK: all BTRFS volumes updated to zstd:3"
echo "    Backup saved to /etc/fstab.bak-$(date +%Y%m%d)"
echo ""
echo "NOTE: zstd:3 takes effect for newly written data."
echo "      To recompress existing data on /home run:"
echo "      sudo btrfs filesystem defragment -r -czstd /home"
echo ""
echo "All done. No reboot required for irqbalance/swappiness."
echo "fstab change is live on next mount (reboot to confirm /home)."
