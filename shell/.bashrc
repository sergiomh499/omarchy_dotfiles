# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
# /etc/omarchy.conf is written by omarchy-dev-link. When absent, force the
# package default instead of preserving a stale inherited dev-link value before
# we decide which rc file to source.
if [[ -f /etc/omarchy.conf ]]; then
  source /etc/omarchy.conf
  export OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"
else
  export OMARCHY_PATH=/usr/share/omarchy
fi
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

[ -f "$HOME/.local/share/../bin/env" ] && . "$HOME/.local/share/../bin/env"
[ -f "$HOME/.env.local" ] && . "$HOME/.env.local"

# Android Tools & Java 17 local path
export PATH="$HOME/.local/tools/usr/bin:$HOME/.local/tools/usr/lib/jvm/java-17-openjdk/bin:$PATH"
export JAVA_HOME="$HOME/.local/tools/usr/lib/jvm/java-17-openjdk"
export ANDROID_HOME="$HOME/.local/android-sdk"
export ANDROID_SDK_ROOT="$HOME/.local/android-sdk"
export ANDROID_AVD_HOME="$HOME/.config/.android/avd"
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator:$PATH"

# Prepend user binaries so local wrappers take precedence over raw mise shims
export PATH="$HOME/.local/bin:$PATH"
alias pi="$HOME/.local/bin/pi"

# Hindsight: trust the homelab's internal Caddy CA (hindsight-api.homelab.local)
if [ -z "$NODE_EXTRA_CA_CERTS" ] && [ -f "$HOME/.config/ssl/caddy-local-root.crt" ]; then
    export NODE_EXTRA_CA_CERTS="$HOME/.config/ssl/caddy-local-root.crt"
fi
