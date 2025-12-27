# {
#   ### ALWAYS REQURIED ###
#   service = "service-name";
#
#  ### CREATING RULE ###
#  subdomain = "some-subdomain"; # Becomes ${subdomain}.${defaultDomain} # OR
#  rule = "Host(`${subdomain}.${defaultDomain}`)"; # Passed through as-is
#
#  ### CREATING LOADBALANCER SERVER ###
#  port = 25575; # Creates "http://127.0.0.1:${toString port}"
#  # OR
#  internalURL = "http://127.0.0.1:whatever";
#
#  ### DEFAULTS ###
#  entrypoints = [ "websecure" ];
#  tls = true;
#
# }

lib: rawServices:
with lib;
let
  defaultDomain = "morganlabs.dev";

  services = map (
    item:
    let
      rule = if (item ? rule) then item.rule else "Host(`${item.subdomain}.${defaultDomain}`)";
      internalURL =
        if (item ? internalURL) then item.internalURL else "http://127.0.0.1:${toString item.port}";
      entrypoints = if (item ? entrypoints) then item.entrypoints else [ "websecure" ];
      tls = if (item ? tls) then item.tls else true;
    in
    with item;
    {
      routers.${service} = {
        inherit
          service
          rule
          entrypoints
          tls
          ;
      };

      services.${service}.loadBalancer.servers = [
        { url = internalURL; }
      ];
    }
  ) rawServices;
in
foldl' recursiveUpdate { } services

# services.traefik.dynamicConfigOptions = mkIf cfg.traefik.enable (mkTraefikService [
#   {
#     service = "mc-rcon";
#     protocol = "https";
#     subdomain = "some-subdomain"; # Automatically appends default domain
#     # OR
#     rule = "Host(`low-power-dash.morganlabs.dev`) && Path(`/ws`)";
#     entrypoints = [ "websecure" ];
#     tls = true;
#     port = 25575;
#     # OR
#     internalURL = "http://127.0.0.1:${toString ports.webpanel}";
#   }
# ]);

# services.traefik.dynamicConfigOptions.http = mkIf cfg.traefik.enable {
#   routers.minecraft-server-rcon = {
#     rule = "Host(`low-power-dash.morganlabs.dev`)";
#     entryPoints = [ "websecure" ];
#     service = "minecraft-server-rcon";
#     tls = true;
#   };

#   routers.minecraft-server-rcon-ws = {
#     rule = "Host(`low-power-dash.morganlabs.dev`) && Path(`/ws`)";
#     entryPoints = [ "websecure" ];
#     service = "minecraft-server-rcon-ws";
#     tls = true;
#   };

#   services.minecraft-server-rcon.loadBalancer.servers = [
#     { url = "http://127.0.0.1:${toString ports.webpanel}"; }
#   ];

#   services.minecraft-server-rcon-ws.loadBalancer.servers = [
#     { url = "http://127.0.0.1:${toString ports.ws}"; }
#   ];
# };
#   };
# }
