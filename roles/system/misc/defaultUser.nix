{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.roles.defaultUser;
in
{
  options.roles.defaultUser = {
    enable = mkEnableOption "SSH";

    features = {
      autologin = mkOption {
        type = types.bool;
        description = "Enable autologin";
        default = true;
      };
    };

    extra = {
      groups = mkOption {
        type = types.listOf types.str;
        description = "The groups that the user is present in";
        default = [ "networkmanager" "wheel" ];
      };
    };

    shell = mkOption {
      type = types.package;
      description = "The user's shell";
      default = pkgs.zsh;
    };

    packages = mkOption {
      type = types.listOf types.str;
      description = "The user's packages";
      default = [];
    };
  };

  config = mkIf cfg.enable {
    # Ony autologin on the first TTY
    systemd.services."getty@tty1" = mkIf cfg.features.autologin {
      overrideStrategy = "asDropin";
      serviceConfig.ExecStart = ["" "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} --autologin ${user.username} --noclear --keep-baud %I 115200,38400,9600 $TERM"];
    };

    users.users.${user.username} = {
      inherit (cfg) packages shell;
      extraGroups = cfg.extra.groups;
      description = user.name;
      isNormalUser = true;
      ignoreShellProgramCheck = true;
    };
  };
}

