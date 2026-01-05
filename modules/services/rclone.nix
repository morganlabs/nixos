{
  config,
  lib,
  vars,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.services.rclone;
in
{
  options.modules.services.rclone = {
    enable = mkEnableOption "Enable services.rclone";
    mounts = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            mountPoint = mkStringOption "Mount point" "";
            bucket = mkStringOption "S3 bucket" "";
            url = mkStringOption "S3 endpoint" "http://127.0.0.1:9000";
            uid = mkStringOption "The UID for the mount" "";
            gid = mkStringOption "The GID for the mount" "";
            umask = mkStringOption "The Umask for the mount" "0022";
          };
        }
      );
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.rclone ];

    systemd.tmpfiles.rules = [
      "d /var/cache/rclone 0755 root root -"
    ];

    age.secrets = {
      minio-username.file = ../../secrets/${vars.hostname}/minio-username.age;
      minio-password.file = ../../secrets/${vars.hostname}/minio-password.age;
    };

    age-template.files."rclone.conf" = {
      owner = "root";
      mode = "0600";
      vars = with config.age.secrets; {
        username = minio-username.path;
        password = minio-password.path;
      };
      content = ''
        [minio]
        type = s3
        provider = Minio
        access_key_id = $username
        secret_access_key = $password
        endpoint = http://127.0.0.1:9000
        force_path_style = true
        no_check_bucket = true
      '';
    };

    environment.etc."rclone/rclone.conf".source = config.age-template.files."rclone.conf".path;

    fileSystems = mkIf cfg.enable (
      listToAttrs (
        map (mount: {
          name = mount.mountPoint;
          value = with mount; {
            device = "minio:${bucket}";
            fsType = "rclone";
            options = [
              "allow_other"
              "_netdev"
              "x-systemd.requires=network-online.target"
              "args2env"
              "uid=${uid}"
              "gid=${gid}"
              "umask=${umask}"

              "vfs-cache-mode=full"
              "vfs-cache-max-size=100G"
              "vfs-cache-max-age=720h"
              "vfs-read-chunk-size=256M"
              "vfs-read-chunk-size-limit=off"
              "vfs-write-back=1s"
              "buffer-size=256M"
              "dir-cache-time=24h"
              "poll-interval=0"
              "no-checksum"
              "no-modtime"
              "use-mmap"
              "fast-list"
              "transfers=32"

              "config=/etc/rclone/rclone.conf"
              "cache-dir=/var/cache/rclone"
            ];
          };
        }) cfg.mounts
      )
    );
  };
}
