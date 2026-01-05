{ config, lib, ... }:
with lib;
let
  cfg = config.modules.services.fprintd;
in
{
  options.modules.services.fprintd = {
    enable = mkEnableOption "Enable services.fprintd";
  };

  config = mkIf cfg.enable {
    services.fprintd.enable = mkForce true;
    security.pam.services.login.fprintAuth = mkForce true;
    services.gnome.gnome-keyring.enable = mkForce true;
    systemd.services.fprintd = {
      wantedBy = mkForce [ "multi-user.target" ];
      serviceConfig.Type = mkForce "simple";
    };
  };
}
