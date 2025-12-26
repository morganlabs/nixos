{
  config,
  lib,
  vars,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.services.minio;

  ports = {
    minio = 9000;
    console = 9001;
  };

  mcScript = pkgs.writeShellScriptBin "mc" ''
    #!/usr/bin/env bash
    set -euo pipefail

    USER=$(cat /run/agenix/minio-username)
    PASS=$(cat /run/agenix/minio-password)

    ${pkgs.minio-client}/bin/mc alias set minio http://127.0.0.1:9000 "$USER" "$PASS" || true
    exec ${pkgs.minio-client}/bin/mc "$@"
  '';
in
{
  options.modules.services.minio = {
    enable = mkEnableOption "Enable services.minio";
    dataDir = mkStringOption "Data directory for MinIO" "/var/lib/minio-data";
    traefik.enable = mkEnableOption "Enable Traefik routing";

    buckets = mkOption {
      description = "Which buckets to create";
      default = [ ];
      type = types.listOf (
        types.submodule {
          options = {
            name = mkOption { type = types.str; };
            policy = mkOption {
              type = types.enum [
                "public"
                "private"
                "readwrite"
                "download"
              ];
              default = "private";
            };
          };
        }
      );
    };
  };

  config = mkIf cfg.enable {
    modules.services.minio.traefik.enable = mkDefault true;
    environment.systemPackages = [ mcScript ];

    age.secrets = {
      minio-username.file = ../../secrets/${vars.hostname}/minio-username.age;
      minio-password.file = ../../secrets/${vars.hostname}/minio-password.age;
    };

    age-template.files."minio-credentials" = {
      vars = with config.age.secrets; {
        username = minio-username.path;
        password = minio-password.path;
      };
      content = ''
        MINIO_ROOT_USER=$username
        MINIO_ROOT_PASSWORD=$password
      '';
    };

    services.minio = {
      enable = mkForce true;
      rootCredentialsFile = config.age-template.files."minio-credentials".path;
      dataDir = [ cfg.dataDir ];
      listenAddress = ":${toString ports.minio}";
      consoleAddress = ":${toString ports.console}";
    };

    systemd.services.minio-buckets = {
      description = "Create MinIO buckets declaratively";
      after = [ "minio.service" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "oneshot";
      script = ''
        export PATH=${mcScript}/bin:/run/current-system/sw/bin

        # Create buckets
        ${concatStringsSep "\n" (
          map (b: ''
            mc mb minio/${b.name} || true
            mc anonymous set ${b.policy} minio/${b.name} || true
          '') cfg.buckets
        )}
      '';
    };

    services.traefik.dynamicConfigOptions = mkIf cfg.traefik.enable {
      http = {
        routers.minio = {
          rule = "Host(`minio.morganlabs.dev`)";
          entryPoints = [ "websecure" ];
          service = "minio";
          tls = true;
        };

        services.minio.loadBalancer.servers = [
          { url = "http://127.0.0.1:${toString ports.console}"; }
        ];
      };
    };
  };
}
