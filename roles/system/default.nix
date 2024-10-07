{ ... }:
{
  imports = [
    ./defaultUser.nix

    ./sound/pipewire.nix

    ./bootloader/grub.nix

    ./misc/i18n.nix
    ./misc/security.nix
    ./misc/defaultFonts.nix

    ./connectivity/ssh.nix
    ./connectivity/firewall.nix
    ./connectivity/networkmanager.nix
    ./connectivity/bluetooth.nix

    ./laptop/powerManagement.nix
  ];
}
