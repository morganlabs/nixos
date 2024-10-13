{ ... }:
{
  imports = [
    ./defaultUser.nix

    ./sound/pipewire.nix
    ./sound/noisetorch.nix

    ./bootloader/grub.nix

    ./misc/i18n.nix
    ./misc/security.nix
    ./misc/defaultFonts.nix

    ./connectivity/ssh.nix
    ./connectivity/firewall.nix
    ./connectivity/bluetooth.nix
    ./connectivity/networkmanager

    ./security/keyring.nix

    ./laptop/powerManagement.nix

    ./programs/1password.nix

    ./desktop/hyprland.nix
  ];
}
