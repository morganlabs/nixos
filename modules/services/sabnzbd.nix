{
  config,
  lib,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.services.sabnzbd;
  port = 8080;
in
{
  options.modules.services.sabnzbd = {
    enable = mkEnableOption "Enable services.sabnzbd";
    traefik.enable = mkEnableOption "Enable Traefik routing";
    group = mkStringOption "The group to run sabnzbd as" config.modules.services.jellyfin.group;
  };

  config = mkIf cfg.enable {
    modules.services.sabnzbd.traefik.enable = mkDefault true;

    age.secrets = {
      usenet-server.file = ../../secrets/${vars.hostname}/usenet-server.age;
      usenet-username.file = ../../secrets/${vars.hostname}/usenet-username.age;
      usenet-password.file = ../../secrets/${vars.hostname}/usenet-password.age;
    };

    age-template.files."sabnzbd.ini" = {
      owner = "sabnzbd";
      mode = "0640";
      vars = with config.age.secrets; {
        server = usenet-server.path;
        username = usenet-username.path;
        password = usenet-password.path;
      };

      content = ''
        __version__ = 19
        __encoding__ = utf-8
        [misc]
        host = 0.0.0.0
        host_whitelist = usenet.morganlabs.dev
        port = ${toString port}
        web_dir = Glitter
        log_dir = /var/lib/sabnzbd/logs
        admin_dir = /var/lib/sabnzbd/admin
        nzb_backup_dir = /var/lib/sabnzbd/backup
        download_dir = /var/lib/sabnzbd/incomplete
        complete_dir = /var/lib/sabnzbd/complete
        permissions = 0775

        [servers]
        [[$server]]
        name = $server
        displayname = $server
        host = $server
        port = 563
        timeout = 60
        username = $username
        password = $password
        connections = 8
        ssl = 1
        ssl_verify = 2
        ssl_ciphers = ""
        enable = 1
        required = 0
        optional = 0
        retention = 0
        expire_date = ""
        quota = ""
        usage_at_start = 0
        priority = 0
        notes = ""

        [categories]

        [[*]]
        name = *
        order = 0
        pp = 3
        script = Default
        dir = default
        newzbin = ""
        priority = 0

        [[movies]]
        name = movies
        order = 1
        pp = ""
        script = Default
        dir = movies
        newzbin = ""
        priority = -100

        [[tv]]
        name = tv
        order = 2
        pp = ""
        script = Default
        dir = tv
        newzbin = ""
        priority = -100

        [[music]]
        name = music
        order = 5
        pp = ""
        script = Default
        dir = music
        newzbin = ""
        priority = -100
      '';
    };

    services.sabnzbd = {
      inherit (cfg) group;
      enable = mkForce true;
      configFile = "/var/lib/sabnzbd/sabnzbd.ini";
    };

    systemd.services.sabnzbd.preStart = with cfg; ''
      if [ ! -f /var/lib/sabnzbd/sabnzbd.ini ]; then
        install -m 644 -o sabnzbd -g ${group} ${
          config.age-template.files."sabnzbd.ini".path
        } /var/lib/sabnzbd/sabnzbd.ini
      fi

      mkdir -p /var/lib/sabnzbd/{incomplete,complete,logs,admin,backup}
      chown sabnzbd:${group} /var/lib/sabnzbd/{incomplete,logs,admin,backup}
      chmod 755 /var/lib/sabnzbd/{incomplete,logs,admin,backup}
      chmod 775 /var/lib/sabnzbd/complete
    '';

    services.traefik.dynamicConfigOptions.http = mkIf cfg.traefik.enable (mkTraefikServices [
      {
        inherit port;
        service = "usenet";
        subdomain = "usenet";
      }
    ]);
  };
}
