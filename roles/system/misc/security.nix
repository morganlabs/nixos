{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.roles.security;
in
{
  options.roles.security = {
    enable = mkEnableOption "Security";
  };

  config = mkIf cfg.enable {
    security = {
      rtkit.enable = true;
      polkit.enable = true;
      sudo.enable = false;
      doas = {
        enable = true;
        extraRules = [{
          users = [ user.username ];
          keepEnv = true;
          persist = true;
        }];
      };
    };
  };
}
