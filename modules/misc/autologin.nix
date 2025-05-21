{
  config,
  lib,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.misc.autologin;
in
{
  options.modules.misc.autologin = {
    enable = mkEnableOption "Enable misc.autologin";
  };

  config = mkIf cfg.enable {
    services.getty = {
      autologinUser = mkForce vars.user.username;
      autologinOnce = mkDefault true;
    };
  };
}
