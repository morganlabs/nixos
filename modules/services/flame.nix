{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.services.flame;

  flameConfig =
    let
      weather = {
        apiKey = "";
        lat = "";
        long = "";
      };
    in
    pkgs.writeText "flame-config.json" (
      builtins.toJSON {
        "WEATHER_API_KEY" = weather.apiKey;
        "lat" = weather.lat;
        "long" = weather.long;
        "isCelsius" = true;

        "customTitle" = "Morgan's Dashboard";
        "pinAppsByDefault" = true;
        "pinCategoriesByDefault" = true;

        "hideHeader" = false;
        "useOrdering" = "orderId";

        "appsSameTab" = false;
        "bookmarksSameTab" = false;
        "searchSameTab" = false;

        "hideApps" = false;
        "hideCategories" = false;
        "hideSearch" = false;

        "defaultSearchProvider" = "l";
        "secondarySearchProvider" = "k";

        "dockerApps" = false;
        "dockerHost" = "localhost";
        "kubernetesApps" = false;

        "unpinStoppedApps" = false;

        "useAmericanDate" = true;

        "disableAutofocus" = false;

        "greetingsSchema" = "Good evening!;Good afternoon!;Good morning!;Good night!";
        "daySchema" = "Sunday;Monday;Tuesday;Wednesday;Thursday;Friday;Saturday";
        "monthSchema" =
          "January;February;March;April;May;June;July;August;September;October;November;December";
        "showTime" = true;
        "hideDate" = false;

        "isKilometer" = false;
        "weatherData" = "cloud";

        "defaultTheme" = "tron";
      }
    );
in
{
  options.modules.services.flame = {
    enable = mkEnableOption "Enable services.flame";
    traefik.enable = mkEnableOption "Enable Traefik integration";
  };

  config = mkIf cfg.enable {
    modules.services = {
      docker.enable = mkForce true;
      flame.traefik.enable = mkDefault true;
    };

    virtualisation.oci-containers = {
      backend = "docker";
      containers.flame = {
        image = "pawelmalak/flame";
        ports = [ "5005:5005" ];
        volumes = [ "/var/local/flame/data:/app/data" ];

        environment.PASSWORD = "password";
        # TODO!: Replace with a password file and agenix
        # environment.PASSWORD_FILE = "whatever goes here :D";
      };
    };

    systemd.services.flame-config = {
      description = "Overwrite Flame config with Nix settings";
      after = [ "docker-flame.service" ];
      requires = [ "docker-flame.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "flame-config" ''
          cp ${flameConfig} /var/local/flame/data/config.json
          chown 1000:1000 /var/local/flame/data/config.json
        '';
      };
    };

    services.traefik.dynamicConfigOptions = mkIf cfg.traefik.enable {
      http = {
        routers.flame = {
          rule = "Host(`dash.morganlabs.dev`)";
          entryPoints = [ "websecure" ];
          service = "flame";
          tls = true;
        };
        services.flame.loadBalancer.servers = [
          { url = "http://127.0.0.1:5005"; }
        ];
      };
    };
  };
}
