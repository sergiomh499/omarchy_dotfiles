source /usr/share/cachyos-zsh-config/cachyos-config.zsh

. "$HOME/.local/share/../bin/env"
[ -f "$HOME/.env.local" ] && . "$HOME/.env.local"

# Prepend user binaries so local wrappers take precedence over raw mise shims
export PATH="$HOME/.local/bin:$PATH"
alias pi="$HOME/.local/bin/pi"
