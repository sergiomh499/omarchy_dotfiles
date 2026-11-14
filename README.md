# Dotfiles (CachyOS / Hyprland / Omarchy)

Personal configuration files and system restoration scripts for Arch Linux (CachyOS) running Hyprland and Omarchy.

## 📁 Repository Structure

Organized into modular, [GNU Stow](https://www.gnu.org/software/stow/)-compatible packages:

| Package | Path | Description |
|---|---|---|
| `hypr` | `~/.config/hypr/` | Hyprland WM, keybindings, monitors, look & feel |
| `waybar` | `~/.config/waybar/` | Status bar layout & styling |
| `walker` | `~/.config/walker/` | Application launcher |
| `mako` | `~/.config/mako/` | Desktop notification daemon |
| `swayosd` | `~/.config/swayosd/` | On-screen display (volume, brightness) |
| `ghostty`, `kitty`, `alacritty`, `foot` | `~/.config/<term>/` | Terminal emulator configs |
| `fish` | `~/.config/fish/` | Fish shell config, completions & env |
| `shell` | `~/.bashrc`, `~/.profile`, `~/.zshrc` | POSIX/Bash/Zsh shell configs |
| `nvim` | `~/.config/nvim/` | Neovim (LazyVim setup) |
| `starship` | `~/.config/starship.toml` | Starship prompt |
| `btop` | `~/.config/btop/` | System monitor & themes |
| `lazygit` | `~/.config/lazygit/` | Git TUI |
| `fastfetch` | `~/.config/fastfetch/` | System info display |
| `git` | `~/.config/git/` | Git global configuration |
| `lazydocker` | `~/.config/lazydocker/` | Docker TUI |
| `micro` | `~/.config/micro/` | Micro terminal editor |
| `wiremix` | `~/.config/wiremix/` | Audio mixer config |
| `fcitx5`, `environment.d` | `~/.config/fcitx5/`, `~/.config/environment.d/` | Input method configuration |
| `hyprland-preview-share-picker` | `~/.config/hyprland-preview-share-picker/` | Screen sharing preview picker |
| `omarchy` | `~/.config/omarchy/` | Custom Omarchy themes, hooks & branding |
| `omp` | `~/.omp/agent/`, `~/.omp/commands/` | Oh My Pi harness configuration, models & custom commands |
| `agents` | `~/.agents/` | Global agent ecosystem rules, cross-delegation skills |
| `gemini` | `~/.gemini/config/` | Antigravity CLI global guidelines (token efficiency, delegation) |
| `hermes` | `hermes/` | Hermes Agent config, SOUL & homelab skills (`sync-hermes.sh`) |
| `misc` | `~/.config/` | Terminal defaults (`xdg-terminals.list`) & `chromium-flags.conf` |
| `scripts` | `~/` | Laptop & NVIDIA driver tuning scripts |
| `packages` | `packages/` | Native & AUR package lists |

---

## 🚀 Quick Install / Bootstrap

On a fresh install or new system:

### 1. Clone Repository
```bash
git clone https://github.com/sergiomh499/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. Run Installer
```bash
# Link all configs (uses GNU Stow if installed, or native symlinks)
./install.sh

# Or restore packages and link configs:
./install.sh --packages
```

### 3. Using GNU Stow directly (Optional)
```bash
# Link individual packages
stow hypr waybar fish nvim

# Unlink a package
stow -D hypr
```

---

## 🔒 Secrets & Environment

Private tokens and secrets are stored in uncommitted local files:
- **Fish:** `~/.config/fish/conf.d/secrets.fish`
- **Bash/Zsh:** `~/.env.local`

---

## 📦 Package Management

To update the package lists:
```bash
pacman -Qqen > ~/dotfiles/packages/pkglist-native.txt
pacman -Qqem > ~/dotfiles/packages/pkglist-foreign.txt
```
