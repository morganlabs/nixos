{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.gamemode;
in
{
  options.modules.programs.gamemode = {
    enable = mkEnableOption "Enable programs.gamemode";
  };

  config = mkIf cfg.enable {
    programs.gamemode.enable = mkForce true;
  };
}
