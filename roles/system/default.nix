{ ... }:
{
  imports = [
    ./bootloader/grub.nix

    ./misc/i18n.nix
    ./misc/security.nix
    ./misc/defaultUser.nix
    ./misc/defaultFonts.nix

    ./sound/pipewire.nix

    ./networking/ssh.nix
    ./networking/firewall.nix
    ./networking/networkmanager.nix
  ];
}
