{
  config,
  lib,
  inputs,
  vars,
  ...
}:
let
  cfg = config.modules.scope.program;
in
with lib;
{
  imports = [ inputs.home-manager.modules.home-manager ];

  options.modules.scope.program = {
    enable = mkEnableOption "Enable scope.program";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = { };
  };
}
