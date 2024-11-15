{ inputs, ... }:
with inputs;
{
  imports = [
    ./desktop/hyprland.nix

    ./decoration/stylix
    stylix.nixosModules.stylix

    ./programs/1password.nix

    ./security/gnome-keyring.nix

    ./connectivity/networkmanager
    ./connectivity/bluetooth.nix
    ./connectivity/firewall.nix
    ./connectivity/ssh.nix
  ];
}
