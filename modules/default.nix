{ inputs, ... }:
{
  imports = with inputs; [
    ./connectivity/networkmanager
    ./connectivity/bluetooth.nix
    ./connectivity/firewall.nix
    ./connectivity/ssh.nix

    ./desktop/hyprland

    ./decoration/stylix

    ./programs/hyprlock.nix
    ./programs/hypridle.nix
  ];
}
