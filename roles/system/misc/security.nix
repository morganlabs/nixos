{
  config,
  lib,
  user,
  ...
}:
with lib;
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
      sudo.enable = if (cfg.features.doas.enable && cfg.features.doas.replaceSudo) then false else true;
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
