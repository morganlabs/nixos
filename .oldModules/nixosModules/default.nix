{ inputs, ... }:
with inputs;
{
  imports = [
    ./desktop/hyprland

    ./decoration/stylix
    stylix.nixosModules.stylix

    ./programs/1password.nix
    ./programs/spotify.nix
    spicetify-nix.nixosModules.default

    ./security/gnome-keyring.nix

    ./connectivity/networkmanager
    ./connectivity/bluetooth.nix
    ./connectivity/firewall.nix
    ./connectivity/ssh.nix
  ];
}
