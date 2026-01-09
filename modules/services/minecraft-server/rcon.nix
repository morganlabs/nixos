{ config, lib, ... }:
with lib;
let
  cfg = config.modules.services.minecraft-server.rcon;

  ports = {
    webpanel = 4326;
    ws = 4327;
    rcon = 25575;
  };
in
{
  options.modules.services.minecraft-server.rcon = {
    enable = mkEnableOption "Enable services.minecraft-server.rcon";
    traefik.enable = mkEnableOption "Enable Traefik routing";
  };

  config = mkIf cfg.enable {
    modules.services.minecraft-server.rcon.traefik.enable = mkDefault true;
    networking.firewall.allowedTCPPorts = [ ports.rcon ];

    virtualisation.oci-containers = {
      backend = "docker";
      containers.minecraft-server-rcon = {
        image = "itzg/rcon";
        extraOptions = [ "--add-host=host.docker.internal:host-gateway" ];

        ports = with ports; [
          "${toString webpanel}:${toString webpanel}"
          "${toString ws}:${toString ws}"
        ];

        environmentFiles = [ config.age-template.files."rcon-env".path ];
        environment = {
          RWA_USERNAME = "admin";
          RWA_RCON_HOST = "172.17.0.1";
          RWA_RCON_PORT = toString ports.rcon;
          RWA_SERVER_NAME = "Low-Power SMP";
          RWA_GAME = "minecraft";
          RWA_WEBSOCKET_URL = "wss://low-power-dash.morganlabs.dev/ws";
          RWA_WEBSOCKET_URL_SSL = "wss://low-power-dash.morganlabs.dev/ws";
        };
      };
    };

    services.minecraft-servers.servers.lps.serverProperties = {
      "enable-rcon" = true;
      "rcon.password" = "@RWA_RCON_PASSWORD@";
      "rcon.port" = ports.rcon;
    };

    services.traefik.dynamicConfigOptions.http = mkIf cfg.traefik.enable (mkTraefikServices [
      {
        service = "mc-rcon";
        subdomain = "low-power-dash";
        port = ports.webpanel;
      }
      {
        service = "mc-rcon-ws";
        rule = "Host(`low-power-dash.morganlabs.dev`) && Path(`/ws`)";
        port = ports.ws;
      }
    ]);
  };
}
