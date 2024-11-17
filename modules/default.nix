{ inputs, ... }:
{
  imports = with inputs; [
    ./connectivity/networkmanager
    ./connectivity/bluetooth.nix
    ./connectivity/firewall.nix
    ./connectivity/ssh.nix

    ./desktop/hyprland

    ./shells/zsh

    ./decoration/stylix

    ./programs/nvim
    ./programs/hyprlock.nix
    ./programs/hypridle.nix
    ./programs/kitty.nix
  ];
}
