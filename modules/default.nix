{
  imports = [
    ./core.nix

    ./bootloader/systemd-boot.nix
    ./bootloader/grub.nix

    ./hardware/bluetooth.nix

    ./networking

    ./services/ssh
    ./services/minecraft-server

    ./programs/git.nix
    ./programs/node.nix
  ];
}
