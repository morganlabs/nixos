{
  config,
  lib,
  vars,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.services.nextcloud;
  port = 4892;
in
{
  imports = [
    "${
      fetchTarball {
        url = "https://github.com/onny/nixos-nextcloud-testumgebung/archive/fa6f062830b4bc3cedb9694c1dbf01d5fdf775ac.tar.gz";
        sha256 = "0gzd0276b8da3ykapgqks2zhsqdv4jjvbv97dsxg0hgrhb74z0fs";
      }
    }/nextcloud-extras.nix"
  ];

  options.modules.services.nextcloud = {
    enable = mkEnableOption "Enable services.nextcloud";
    traefik.enable = mkEnableOption "Enable Traefik routing";
  };

  config = mkIf cfg.enable {
    modules.services.nextcloud.traefik.enable = mkDefault true;

    age.secrets = {
      nextcloud-admin-password.file = ../../secrets/${vars.hostname}/nextcloud-admin-password.age;
      nextcloud-morgan-password.file = ../../secrets/${vars.hostname}/nextcloud-admin-password.age;
      minio-username.file = ../../secrets/${vars.hostname}/minio-username.age;
      minio-password.file = ../../secrets/${vars.hostname}/minio-password.age;
    };

    services.nextcloud = {
      enable = mkForce true;
      package = pkgs.nextcloud32;
      hostName = if cfg.traefik.enable then "cloud.morganlabs.dev" else "localhost";
      https = true;
      configureRedis = true;
      database.createLocally = true;

      ensureUsers.jmorgan = {
        email = vars.user.email.personal;
        passwordFile = config.age.secrets.nextcloud-morgan-password.path;
      };

      appstoreEnable = false;
      extraAppsEnable = true;
      extraApps = {
        inherit (config.services.nextcloud.package.packages.apps)
          twofactor_admin
          twofactor_webauthn
          unroundedcorners
          # maps
          quota_warning
          ;
      };

      config = {
        adminpassFile = config.age.secrets.nextcloud-admin-password.path;

        dbtype = "mysql";
        dbuser = "nextcloud";
        dbname = "nextcloud";
        # dbpassFile = config.age.secrets.maria-pass.path;

        objectstore.s3 = {
          enable = true;
          bucket = "cloud";
          verify_bucket_exists = true;
          key = "5UIVO7EW7dZaUxBQ7HKMENwLA2A6XKquKJXwgxxTZGw=";
          secretFile = config.age.secrets.minio-password.path;
          hostname = "localhost";
          useSsl = false;
          port = 9000;
          usePathStyle = true;
          region = "us-east-1";
        };
      };
    };

    services.nginx.virtualHosts."${config.services.nextcloud.hostName}".listen = [
      {
        inherit port;
        addr = "127.0.0.1";
      }
    ];

    services.mysql = {
      enable = true;
      package = pkgs.mariadb;
      ensureDatabases = [ "nextcloud" ];
      ensureUsers = [
        {
          name = "nextcloud";
          ensurePermissions."nextcloud.*" = "ALL PRIVILEGES";
        }
      ];
    };

    services.traefik.dynamicConfigOptions.http = mkIf cfg.traefik.enable (mkTraefikServices [
      {
        inherit port;
        service = "cloud";
        subdomain = "cloud";
      }
    ]);
  };
}
