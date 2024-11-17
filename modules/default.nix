{ inputs, ... }:
{
  imports = with inputs; [
    ./base/xdgUserDirs.nix

    ./connectivity/networkmanager
    ./connectivity/bluetooth.nix
    ./connectivity/firewall.nix
    ./connectivity/ssh.nix

    ./security/gnome-keyring.nix

    ./desktop/hyprland

    ./shells/zsh

    ./decoration/stylix

    ./programs/nvim
    ./programs/rofi
    ./programs/waybar
    ./programs/hyprlock.nix
    ./programs/hypridle.nix
    ./programs/kitty.nix
    ./programs/bat.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/btop.nix
    ./programs/unzip.nix
    ./programs/eza.nix
    ./programs/pfetch.nix
    ./programs/spotify.nix
    ./programs/1password.nix
    ./programs/nextcloud-client.nix
    ./programs/obsidian.nix
    ./programs/signal.nix
    ./programs/element.nix
  ];
}
