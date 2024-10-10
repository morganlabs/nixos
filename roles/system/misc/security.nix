{
  config,
  lib,
  myLib,
  user,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.misc.security;
in
{
  options.roles.misc.security = {
    enable = mkEnableOption "Security";

    features.doas = {
      enable = mkOption {
        type = types.bool;
        description = "Use doas instead of sudo";
        default = true;
      };

      replaceSudo = mkOption {
        type = types.bool;
        description = "Use doas instead of sudo";
        default = true;
      };
    };
  };

  config = mkIf cfg.enable {
    security = {
      rtkit.enable = true;
      polkit.enable = true;
      sudo.enable = mkIfElse (cfg.features.doas.enable && cfg.features.doas.replaceSudo) false true;
      doas = mkIf cfg.features.doas.enable {
        enable = true;
        extraRules = [
          {
            users = [ user.username ];
            keepEnv = true;
            persist = true;
          }
        ];
      };
    };
  };
}
