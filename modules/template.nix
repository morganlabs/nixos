{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.SCOPE.NAME;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.SCOPE.NAME = {
    enable = mkEnableOption "Enable SCOPE.NAME";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = { };
  };
}
