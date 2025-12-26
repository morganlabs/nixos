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
    ./services/minio.nix
    ./services/s3fs.nix
    ./services/navidrome.nix
    ./services/jellyfin.nix

    ./programs/git.nix
    ./programs/node.nix
  ];
}
