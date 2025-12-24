# CLOUDFLARE ORIGIN CERTIFICATE (because i know youll forget if you need to do this again)
## CREATING CERTIFICATE ##
# Login to Cloudflare dash and go to domain
# SSL/TLS => Origin Server => Create Certificate
# RSA (2048)
# *.morganlabs.dev (morganlabs.dev root domain not neccesary)
# Key Format PEM
# Save public cert: /etc/ssl/certs/cloudflare-origin.crt
# Save private key: /etc/ssl/private/cloudflare-origin.key
## SET FILE PERMISSIONS ##
# sudo chown root:traefik /etc/ssl/certs/cloudflare-origin.crt
# sudo chmod 644 /etc/ssl/certs/cloudflare-origin.crt
# sudo chown root:traefik /etc/ssl/private/cloudflare-origin.key
# sudo chmod 640 /etc/ssl/private/cloudflare-origin.key

## DISCLAIMER ##
# Do NOT upload the key/cert to a repo!!!!!!!!!

{ config, lib, ... }:
with lib;
let
  cfg = config.modules.services.traefik;
in
{
  options.modules.services.traefik = {
    enable = mkEnableOption "Enable services.traefik";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkAfter [
      8080
      80
      443
    ];
    services.traefik = {
      enable = true;

      dynamicConfigOptions = {
        tls.stores.default.defaultCertificate = {
          certFile = "/etc/ssl/certs/cloudflare-origin.crt";
          keyFile = "/etc/ssl/private/cloudflare-origin.key";
        };

        tls = {
          certificates = [
            {
              certFile = "/etc/ssl/certs/cloudflare-origin.crt";
              keyFile = "/etc/ssl/private/cloudflare-origin.key";
            }
          ];
        };

        http.routers.traefik = {
          rule = "Host(`traefik.morganlabs.dev`)";
          service = "api@internal";
          entryPoints = [ "websecure" ];
          tls = true;
        };
      };

      staticConfigOptions = {
        entryPoints = {
          web = {
            address = ":80";
            asDefault = true;
            http.redirections.entrypoint = {
              to = "websecure";
              scheme = "https";
            };
          };

          websecure = {
            address = ":443";
            asDefault = true;
          };
        };

        api = {
          dashboard = true;
          insecure = true;
        };
      };
    };
  };
}
