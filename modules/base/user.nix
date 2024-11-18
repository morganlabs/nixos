{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
let
  cfg = config.modules.base.user;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.base.user = {
    enable = mkEnableOption "Enable base.user";
    features.autologin.enable = mkBoolOption "Automatically log in to TTY1" false;
  };

  config = mkIf cfg.enable {
    users.users.${vars.user.username} = {
      isNormalUser = mkForce true;
      description = mkForce vars.user.name;
      extraGroups = mkDefault [ "wheel" ];
    };

    systemd.services."getty@tty1" = mkForce (
      mkIf cfg.features.autologin.enable ({
        overrideStrategy = "asDropin";
        serviceConfig.ExecStart = [
          ""
          "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} --autologin ${vars.user.username} --noclear --keep-baud %I 115200,38400,9600 $TERM"
        ];
      })
    );
  };
}
