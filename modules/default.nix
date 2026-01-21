{
  imports = [
    ./core.nix

    ./bootloader/systemd-boot.nix
    ./bootloader/grub.nix
    ./bootloader/lanzaboote.nix

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
    ./services/status.nix
    ./services/lidarr.nix
    ./services/sabnzbd.nix
    ./services/power-management.nix
    ./services/fprintd.nix
    ./services/vaultwarden.nix
    ./services/nextcloud.nix

    ./programs/nvim
    ./programs/git.nix
    ./programs/node.nix
    ./programs/stylix
    ./programs/firefox
    ./programs/prism-launcher.nix
    ./programs/_1password.nix
    ./programs/bitwarden.nix
    ./programs/steam.nix
    ./programs/gamemode.nix
    ./programs/mangohud.nix
    ./programs/obsidian.nix
    ./programs/microsoft-edge.nix

    ./desktop/hyprland
  ];
}
