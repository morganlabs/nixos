{ config, lib, ... }:
with lib;
let
  cfg = config.modules.services.uptime-kuma;
  port = 3001;
in
{
  options.modules.services.uptime-kuma = {
    enable = mkEnableOption "Enable services.uptime-kuma";
    traefik.enable = mkEnableOption "Enable Traefik routing";
  };

  config = mkIf cfg.enable {
    modules.services.uptime-kuma.traefik.enable = mkDefault true;

    services.uptime-kuma = {
      enable = mkForce true;
      settings = {
        UPTIME_KUMA_PORT = mkForce (toString port);
      };
    };

    services.traefik.dynamicConfigOptions.http = mkIf cfg.traefik.enable (mkTraefikServices [
      {
        inherit port;
        service = "uptime-kuma";
        subdomain = "status";
      }
    ]);
  };
}
