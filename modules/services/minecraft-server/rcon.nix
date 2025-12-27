{
  config,
  lib,
  vars,
  ...
}:
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
    # age.secrets.minecraft-rcon-password.file = ../../../secrets/${vars.hostname}/minecraft-rcon-password.age;

    # age-template.files."rcon-env" = {
    #   vars.rconPassword = config.age.secrets.minecraft-rcon-password.path;
    #   content = ''
    #     RWA_RCON_PASSWORD=$rconPassword
    #   '';
    # };

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
          RWA_RCON_HOST = "host.docker.internal";
          RWA_RCON_PORT = toString ports.rcon;
        };
      };
    };

    services.minecraft-servers.servers = {
      # environmentFile = toString config.age-template.files."rcon-env".path;
      fabric.serverProperties = {
        "enable-rcon" = true;
        "rcon.password" = "@RWA_RCON_PASSWORD@";
        "rcon.port" = ports.rcon;
      };
    };

    services.traefik.dynamicConfigOptions = mkIf cfg.traefik.enable {
      http = {
        routers.minecraft-server-rcon = {
          rule = "Host(`low-power-dash.morganlabs.dev`)";
          entryPoints = [ "websecure" ];
          service = "minecraft-server-rcon";
          tls = true;
        };

        routers.minecraft-server-rcon-ws = {
          rule = "Host(`low-power-dash.morganlabs.dev`) && PathPrefix(`/ws`)";
          entryPoints = [ "websecure" ];
          service = "minecraft-server-rcon-ws";
          tls = true;
        };

        services.minecraft-server-rcon.loadBalancer.servers = [
          { url = "http://127.0.0.1:${toString ports.webpanel}"; }
        ];

        services.minecraft-server-rcon-ws.loadBalancer.servers = [
          { url = "ws://127.0.0.1:${toString ports.ws}"; }
        ];
      };
    };
  };
}
