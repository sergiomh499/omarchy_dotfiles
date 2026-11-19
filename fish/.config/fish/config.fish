# Optional CachyOS layer (package cachyos-fish-config); omarchy-fish ships its own via vendor_conf.d
test -f /usr/share/cachyos-fish-config/cachyos-config.fish; and source /usr/share/cachyos-fish-config/cachyos-config.fish

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

# Prepend user binaries so local wrappers take precedence over raw mise shims
fish_add_path --prepend $HOME/.local/bin

# Hindsight: trust the homelab's internal Caddy CA (hindsight-api.homelab.local)
if not set -q NODE_EXTRA_CA_CERTS; and test -f $HOME/.config/ssl/caddy-local-root.crt
    set -gx NODE_EXTRA_CA_CERTS $HOME/.config/ssl/caddy-local-root.crt
end
