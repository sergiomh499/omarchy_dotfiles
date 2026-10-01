
. "$HOME/.local/share/../bin/env"
[ -f "$HOME/.env.local" ] && . "$HOME/.env.local"

export ANDROID_HOME="$HOME/.local/android-sdk"
export ANDROID_SDK_ROOT="$HOME/.local/android-sdk"
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator:$PATH"
