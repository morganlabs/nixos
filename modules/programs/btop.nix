{
  config,
  lib,
  inputs,
  vars,
  ...
}:
let
  cfg = config.modules.programs.btop;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.btop = {
    enable = mkEnableOption "Enable programs.btop";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      stylix.targets.btop.enable = true;
      programs.btop.enable = true;
    };
  };
}
