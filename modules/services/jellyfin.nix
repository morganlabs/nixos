{
  config,
  lib,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.services.jellyfin;
  internalPort = 8096;
in
{
  imports = [ inputs.jellarr.nixosModules.default ];

  options.modules.services.jellyfin = {
    enable = mkEnableOption "Enable services.jellyfin";
    traefik.enable = mkEnableOption "Enable Traefik routing";
  };

  config = mkIf cfg.enable {
    modules.services.jellyfin.traefik.enable = mkDefault true;

    services.jellyfin = {
      enable = mkForce true;
      user = mkForce "jellyfin";
      group = mkForce "jellyfin";
    };

    services.jellarr = {
      enable = mkForce true;
      user = mkForce "jellyfin";
      group = mkForce "jellyfin";
      config = {
        base_url = mkForce "http://127.0.0.1:${toString internalPort}";
        system.enableMetrics = mkForce true;
      };
    };

    services.traefik.dynamicConfigOptions = mkIf cfg.traefik.enable {
      http = {
        routers.jellyfin = {
          rule = "Host(`jellyfin.morganlabs.dev`)";
          entryPoints = [ "websecure" ];
          service = "jellyfin";
          tls = true;
        };

        services.jellyfin.loadBalancer.servers = [
          { url = "http://127.0.0.1:${toString internalPort}"; }
        ];
      };
    };
  };
}
