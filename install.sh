#!/usr/bin/env bash
# Dotfiles installer & bootstrapper for CachyOS / Arch Linux (Hyprland)
# Works with GNU Stow (if installed) or falls back to native symlinking.

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# List of stow-compatible packages
PACKAGES=(
  aether
  alacritty
  btop
  environment.d
  fastfetch
  fcitx5
  fish
  fontconfig
  foot
  ghostty
  git
  hypr
  hyprland-preview-share-picker
  imv
  kitty
  lazydocker
  lazygit
  mako
  micro
  misc
  nvim
  omarchy
  omp
  starship
  swayosd
  tmux
  uwsm
  walker
  waybar
  wiremix
)

link_with_stow() {
  echo "==> Linking packages with GNU Stow..."
  cd "$DOTFILES_DIR"
  for pkg in "${PACKAGES[@]}"; do
    if [ -d "$pkg" ]; then
      echo "  stow: $pkg"
      stow -R "$pkg" -t "$HOME" 2>/dev/null || stow "$pkg" -t "$HOME"
    fi
  done
}

link_manually() {
  echo "==> Linking packages with native symlinks..."
  mkdir -p "$HOME/.config"
  for pkg in "${PACKAGES[@]}"; do
    if [ -d "$DOTFILES_DIR/$pkg/.config" ]; then
      for item in "$DOTFILES_DIR/$pkg/.config"/*; do
        [ -e "$item" ] || continue
        base="$(basename "$item")"
        target="$HOME/.config/$base"
        
        if [ -e "$target" ] && [ ! -L "$target" ]; then
          mkdir -p "$BACKUP_DIR"
          echo "  backing up existing ~/.config/$base -> $BACKUP_DIR/"
          mv "$target" "$BACKUP_DIR/"
        fi
        
        echo "  symlinking ~/.config/$base -> $item"
        ln -sfn "$item" "$target"
      done
    fi
  done
}

link_shell_files() {
  echo "==> Linking shell dotfiles..."
  for file in .bashrc .profile .zshrc; do
    if [ -f "$DOTFILES_DIR/shell/$file" ]; then
      target="$HOME/$file"
      if [ -e "$target" ] && [ ! -L "$target" ]; then
        mkdir -p "$BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
      fi
      ln -sf "$DOTFILES_DIR/shell/$file" "$target"
      echo "  symlinking ~/$file"
    fi
  done
}
link_omp_files() {
  if [ -d "$DOTFILES_DIR/omp/.omp/agent" ]; then
    echo "==> Linking OMP agent configs..."
    mkdir -p "$HOME/.omp/agent"
    for file in config.yml models.yml; do
      if [ -f "$DOTFILES_DIR/omp/.omp/agent/$file" ]; then
        target="$HOME/.omp/agent/$file"
        if [ -e "$target" ] && [ ! -L "$target" ]; then
          mkdir -p "$BACKUP_DIR"
          echo "  backing up existing ~/.omp/agent/$file -> $BACKUP_DIR/"
          mv "$target" "$BACKUP_DIR/"
        fi
        ln -sfn "$DOTFILES_DIR/omp/.omp/agent/$file" "$target"
        echo "  symlinking ~/.omp/agent/$file"
      fi
    done
  fi
}


install_packages() {
  echo "==> Installing system packages..."
  if command -v pacman &>/dev/null && [ -f "$DOTFILES_DIR/packages/pkglist-native.txt" ]; then
    echo "Installing native repo packages..."
    sudo pacman -S --needed --noconfirm - < "$DOTFILES_DIR/packages/pkglist-native.txt"
  fi
  if [ -f "$DOTFILES_DIR/packages/pkglist-foreign.txt" ] && [ -s "$DOTFILES_DIR/packages/pkglist-foreign.txt" ]; then
    local aur_helper=""
    command -v yay &>/dev/null && aur_helper="yay"
    command -v paru &>/dev/null && aur_helper="paru"
    if [ -n "$aur_helper" ]; then
      echo "Installing foreign/AUR packages using $aur_helper..."
      "$aur_helper" -S --needed --noconfirm - < "$DOTFILES_DIR/packages/pkglist-foreign.txt"
    fi
  fi
}

main() {
  echo "=========================================="
  echo "        Dotfiles Installation            "
  echo "=========================================="
  
  if [[ "${1:-}" == "--packages" ]] || [[ "${1:-}" == "-p" ]]; then
    install_packages
  fi

  if command -v stow &>/dev/null; then
    link_with_stow
  else
    link_manually
  fi

  link_shell_files
  link_omp_files


  # Re-apply current Omarchy theme if present
  if command -v omarchy &>/dev/null && [ -f "$HOME/.config/omarchy/current/theme.name" ]; then
    current_theme="$(cat "$HOME/.config/omarchy/current/theme.name")"
    echo "==> Restoring Omarchy theme ($current_theme)..."
    omarchy theme set "$current_theme" 2>/dev/null || true
  fi

  # Ensure secrets template exists if not already present
  if [ ! -f "$HOME/.config/fish/conf.d/secrets.fish" ]; then
    mkdir -p "$HOME/.config/fish/conf.d"
    cat << 'EOF' > "$HOME/.config/fish/conf.d/secrets.fish"
# Local secrets (ignored in git)
# set -gx GITHUB_TOKEN your_token_here
EOF
    chmod 600 "$HOME/.config/fish/conf.d/secrets.fish"
  fi

  if [ ! -f "$HOME/.env.local" ]; then
    cat << 'EOF' > "$HOME/.env.local"
# Local secrets (ignored in git)
# export GITHUB_TOKEN=your_token_here
EOF
    chmod 600 "$HOME/.env.local"
  fi

  echo ""
  echo "Dotfiles installed successfully!"
  if [ -d "$BACKUP_DIR" ]; then
    echo "Existing configs were backed up to: $BACKUP_DIR"
  fi
  echo "=========================================="
}

main "$@"
