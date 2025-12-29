{ config, lib, ... }:
with lib;
let
  cfg = config.modules.services.lidarr;
  port = 8686;
in
{
  options.modules.services.lidarr = {
    enable = mkEnableOption "Enable services.lidarr";
    traefik.enable = mkEnableOption "Enable Traefik routing";
    group = mkStringOption "The group to run Lidarr as" config.modules.services.jellyfin.group;
  };

  config = mkIf cfg.enable {
    modules.services.lidarr.traefik.enable = mkDefault true;

    services.lidarr = {
      inherit (cfg) group;
      enable = mkForce true;
      settings.server.port = port;
    };

    services.traefik.dynamicConfigOptions.http = mkIf cfg.traefik.enable (mkTraefikServices [
      {
        inherit port;
        service = "lidarr";
        subdomain = "lidarr";
      }
    ]);
  };
}
