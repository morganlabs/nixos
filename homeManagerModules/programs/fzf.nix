{ config, lib, ... }:
let
  cfg = config.homeManagerModules.programs.fzf;
in
with lib;
{
  options.homeManagerModules.programs.fzf = {
    enable = mkEnableOption "Enable programs.fzf";
  };

  config = mkIf cfg.enable {
    stylix.targets.fzf.enable = true;
    programs.fzf.enable = true;
  };
}
