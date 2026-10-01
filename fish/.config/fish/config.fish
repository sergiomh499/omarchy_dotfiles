source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# bun
set --export BUN_INSTALL "$HOME/.bun"
fish_add_path $BUN_INSTALL/bin

# Android SDK
set --export ANDROID_HOME "$HOME/.local/android-sdk"
set --export ANDROID_SDK_ROOT "$HOME/.local/android-sdk"
set --export ANDROID_AVD_HOME "$HOME/.config/.android/avd"
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin
fish_add_path $ANDROID_HOME/emulator
