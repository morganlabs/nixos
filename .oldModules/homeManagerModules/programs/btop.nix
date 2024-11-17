{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
let
  cfg = config.homeManagerModules.programs.btop;
in
with lib;
{
  options.homeManagerModules.programs.btop = {
    enable = mkEnableOption "Enable programs.btop";
  };

  config = mkIf cfg.enable {
    stylix.targets.btop.enable = true;
    programs.btop.enable = true;
  };
}
