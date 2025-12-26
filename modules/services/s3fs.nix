{
  config,
  lib,
  vars,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.services.s3fs;
in
{
  options.modules.services.s3fs = {
    enable = mkEnableOption "Enable services.s3fs";
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
    environment.systemPackages = [ pkgs.s3fs ];

    age.secrets = {
      minio-username.file = ../../secrets/${vars.hostname}/minio-username.age;
      minio-password.file = ../../secrets/${vars.hostname}/minio-password.age;
    };

    age-template.files."s3fs-credentials" = {
      vars = with config.age.secrets; {
        username = minio-username.path;
        password = minio-password.path;
      };

      content = ''$username:$password'';
    };

    fileSystems = mkIf cfg.enable (
      listToAttrs (
        map (mount: {
          name = mount.mountPoint;
          value = {
            device = mount.bucket;
            fsType = "s3fs";
            options = [
              "allow_other"
              "url=${mount.url}"
              "passwd_file=${config.age-template.files.s3fs-credentials.path}"
              "_netdev"
              "uid=${mount.uid}"
              "gid=${mount.gid}"
              "umask=${mount.umask}"
              "use_path_request_style"
            ];
          };
        }) cfg.mounts
      )
    );
  };
}
