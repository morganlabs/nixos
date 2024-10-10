{
  config,
  user,
  lib,
  myLib,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.programs._1password;
in
{
  options.roles.programs._1password = {
    enable = mkEnableOption "Enable 1Password";
  };

  config = mkIf cfg.enable {
    programs = {
      _1password.enable = true;
      _1password-gui = {
        enable = true;
        polkitPolicyOwners = [ user.username ];
      };
    };
  };
}
