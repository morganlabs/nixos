{
  imports = [
    ./bundles/shell.nix
    ./bundles/connectivity.nix
    ./bundles/hyprland.nix
    ./bundles/desktop.nix
    ./bundles/sound.nix
    ./bundles/gaming.nix
    ./bundles/gamedev.nix

    ./base/user.nix
    ./base/locale.nix
    ./base/xdgUserDirs.nix

    ./functions/screenshot
    ./functions/volume
    ./functions/music.nix
    ./functions/backlight.nix

    ./connectivity/networkmanager
    ./connectivity/bluetooth.nix
    ./connectivity/firewall.nix
    ./connectivity/ssh.nix

    ./sound/pipewire.nix
    ./sound/noisetorch.nix

    ./graphics/amdgpu.nix

    ./security/gnome-keyring.nix
    ./security/sudo.nix

    ./desktop/hyprland

    ./shells/zsh

    ./decoration/stylix

    ./programs/rofi
    ./programs/waybar
    ./programs/firefox
    ./programs/tmux
    ./programs/cider2
    ./programs/mako.nix
    ./programs/hyprlock.nix
    ./programs/hypridle.nix
    ./programs/hyprpolkitagent.nix
    ./programs/bat.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/btop.nix
    ./programs/unzip.nix
    ./programs/eza.nix
    ./programs/pfetch.nix
    ./programs/tidal.nix
    ./programs/1password.nix
    ./programs/obsidian.nix
    ./programs/signal.nix
    ./programs/element.nix
    ./programs/steam.nix
    ./programs/libresprite.nix
    ./programs/godot.nix
    ./programs/pcloud.nix
    ./programs/onlyoffice.nix
    ./programs/solaar.nix
  ];
}
