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
    ./services/rclone.nix
    ./services/navidrome.nix
    ./services/jellyfin.nix
    ./services/status.nix
    ./services/sonarr.nix
    ./services/lidarr.nix
    ./services/sabnzbd.nix

    ./programs/nvim
    ./programs/git.nix
    ./programs/node.nix
  ];
}
