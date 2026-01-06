{
  config,
  lib,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.SCOPE.NAME;
in
{
  options.modules.SCOPE.NAME = {
    enable = mkEnableOption "Enable SCOPE.NAME";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = { };
  };
}
