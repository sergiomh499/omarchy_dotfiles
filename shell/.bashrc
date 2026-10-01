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

. "$HOME/.local/share/../bin/env"
[ -f "$HOME/.env.local" ] && . "$HOME/.env.local"

# Android Tools & Java 17 local path
export PATH="$HOME/.local/tools/usr/bin:$HOME/.local/tools/usr/lib/jvm/java-17-openjdk/bin:$PATH"
export JAVA_HOME="$HOME/.local/tools/usr/lib/jvm/java-17-openjdk"
export ANDROID_HOME="$HOME/.local/android-sdk"
export ANDROID_SDK_ROOT="$HOME/.local/android-sdk"
export ANDROID_AVD_HOME="$HOME/.config/.android/avd"
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator:$PATH"
