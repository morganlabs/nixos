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
  };

  config = mkIf cfg.enable {
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

      s3fs = mkIf cfg.useMinIO {
        enable = mkForce true;
        mounts = mkAfter [
          {
            mountPoint = "/mnt/music";
            bucket = "music";
            uid = "navidrome";
            gid = "navidrome";
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

    services.traefik.dynamicConfigOptions = mkIf cfg.traefik.enable {
      http = {
        routers.navidrome = {
          rule = "Host(`music.morganlabs.dev`)";
          entryPoints = [ "websecure" ];
          service = "navidrome";
          tls = true;
        };

        services.navidrome.loadBalancer.servers = [
          { url = "http://127.0.0.1:${toString port}"; }
        ];
      };
    };
  };
}
