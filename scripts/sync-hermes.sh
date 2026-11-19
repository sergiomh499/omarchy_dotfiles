#!/usr/bin/env bash
# Sync Hermes Agent configuration and skills from dotfiles to hermes-ct
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
HERMES_DIR="$DOTFILES_DIR/hermes"
TARGET_HOST="hermes-ct"
PVE_HOST="root@192.168.1.100"

echo "==> Checking connectivity to $TARGET_HOST or PVE ($PVE_HOST)..."
if ssh -o BatchMode=yes -o ConnectTimeout=3 "$TARGET_HOST" "true" 2>/dev/null; then
  echo "==> Syncing directly to $TARGET_HOST..."
  scp -q "$HERMES_DIR/config.yaml" "$TARGET_HOST:/opt/data/config.yaml"
  scp -q "$HERMES_DIR/SOUL.md" "$TARGET_HOST:/opt/data/SOUL.md"
  ssh -q "$TARGET_HOST" "mkdir -p /opt/data/skills/workstation-delegation"
  scp -q "$HERMES_DIR/skills/workstation-delegation/SKILL.md" "$TARGET_HOST:/opt/data/skills/workstation-delegation/SKILL.md"
  echo "==> Reloading Hermes Gateway on $TARGET_HOST..."
  ssh -q "$TARGET_HOST" "kill -TERM \$(pgrep -f 'gateway run') 2>/dev/null" || true
elif ssh -o BatchMode=yes -o ConnectTimeout=5 "$PVE_HOST" "true" 2>/dev/null; then
  echo "==> Direct $TARGET_HOST SSH unreachable; syncing via PVE host ($PVE_HOST)..."
  scp -q "$HERMES_DIR/config.yaml" "$PVE_HOST:/data/appdata/hermes/config.yaml"
  scp -q "$HERMES_DIR/SOUL.md" "$PVE_HOST:/data/appdata/hermes/SOUL.md"
  ssh -q "$PVE_HOST" "chown 110000:110000 /data/appdata/hermes/config.yaml /data/appdata/hermes/SOUL.md && chmod 600 /data/appdata/hermes/config.yaml"
  ssh -q "$PVE_HOST" "pct exec 125 -- mkdir -p /opt/data/skills/workstation-delegation"
  scp -q "$HERMES_DIR/skills/workstation-delegation/SKILL.md" "$PVE_HOST:/data/appdata/hermes/skills/workstation-delegation/SKILL.md"
  ssh -q "$PVE_HOST" "chown -R 110000:110000 /data/appdata/hermes/skills/workstation-delegation"
  echo "==> Reloading Hermes Gateway via PVE pct exec..."
  ssh -q "$PVE_HOST" "pct exec 125 -- pkill -TERM -f 'gateway run'" || true
else
  echo "ERROR: Cannot reach $TARGET_HOST or $PVE_HOST via SSH."
  exit 1
fi

echo "==> Done! Hermes Agent successfully updated."
