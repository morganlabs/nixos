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
