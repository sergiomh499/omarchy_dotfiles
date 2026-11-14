#!/usr/bin/env bash
# Sync Hermes Agent configuration and skills from dotfiles to hermes-ct
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
HERMES_DIR="$DOTFILES_DIR/hermes"
TARGET_HOST="hermes-ct"

echo "==> Checking connectivity to $TARGET_HOST..."
if ! ssh -o BatchMode=yes -o ConnectTimeout=5 "$TARGET_HOST" "true" 2>/dev/null; then
  echo "ERROR: Cannot reach $TARGET_HOST via SSH. Make sure Tailscale or SSH proxy is active."
  exit 1
fi

echo "==> Syncing config.yaml and SOUL.md..."
scp -q "$HERMES_DIR/config.yaml" "$TARGET_HOST:/opt/data/config.yaml"
scp -q "$HERMES_DIR/SOUL.md" "$TARGET_HOST:/opt/data/SOUL.md"

echo "==> Syncing skills..."
ssh -q "$TARGET_HOST" "mkdir -p /opt/data/skills/workstation-delegation"
scp -q "$HERMES_DIR/skills/workstation-delegation/SKILL.md" "$TARGET_HOST:/opt/data/skills/workstation-delegation/SKILL.md"

echo "==> Reloading Hermes Gateway..."
ssh -q "$TARGET_HOST" "kill -TERM \$(pgrep -f 'gateway run') 2>/dev/null" || true

echo "==> Done! Hermes Agent successfully updated."
