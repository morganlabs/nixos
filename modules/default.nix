{
  imports = [
    ./core.nix

    ./bootloader/systemd-boot.nix
    ./bootloader/grub.nix

    ./hardware/bluetooth.nix

    ./networking

    ./services/ssh
    ./services/minecraft-server
    ./services/traefik.nix
    ./services/flame.nix
    ./services/docker.nix

    ./programs/git.nix
    ./programs/node.nix
  ];
}
