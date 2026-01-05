{ config, lib, ... }:
with lib;
let
  cfg = config.modules.services.sonarr;
  port = 8989;
in
{
  options.modules.services.sonarr = {
    enable = mkEnableOption "Enable services.sonarr";
    traefik.enable = mkEnableOption "Enable Traefik routing";
    group = mkStringOption "The group to run Sonarr as" config.modules.services.jellyfin.group;
  };

  config = mkIf cfg.enable {
    modules.services.sonarr.traefik.enable = mkDefault true;

    services.sonarr = {
      inherit (cfg) group;
      enable = mkForce true;
      settings.server.port = port;
    };

    services.traefik.dynamicConfigOptions.http = mkIf cfg.traefik.enable (mkTraefikServices [
      {
        inherit port;
        service = "sonarr";
        subdomain = "sonarr";
      }
    ]);
  };
}
