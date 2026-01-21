{ config, lib, ... }:
with lib;
let
  cfg = config.modules.services.navidrome;

  port = 4533;
in
{
  options.modules.services.navidrome = {
    enable = mkEnableOption "Enable services.navidrome";
    useMinIO = mkEnableOption "Use MinIO for storage";
    traefik.enable = mkEnableOption "Enable Traefik routing";
    group = mkStringOption "The group to run Navidrome as" "media";
  };

  config = mkIf cfg.enable {
    users.groups.media = { };

    modules.services = {
      navidrome.traefik.enable = mkDefault true;
      minio = mkIf cfg.useMinIO {
        enable = mkForce true;
        buckets = mkAfter [
          {
            name = "music";
            policy = "download";
          }
        ];
      };

      rclone = mkIf cfg.useMinIO {
        enable = mkForce true;
        mounts = mkAfter [
          {
            mountPoint = "/mnt/music";
            bucket = "music";
            uid = "navidrome";
            gid = cfg.group;
            umask = "0007";
          }
        ];
      };
    };

    services.navidrome = {
      enable = true;
      settings = {
        MusicFolder = mkForce (mkIfElse cfg.useMinIO "/mnt/music" "/srv/music");
      };
    };

    services.traefik.dynamicConfigOptions.http = mkIf cfg.traefik.enable (mkTraefikServices [
      {
        inherit port;
        service = "navidrome";
        subdomain = "music";
      }
    ]);
  };
}
