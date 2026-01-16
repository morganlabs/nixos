{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.obsidian;
in
{
  options.modules.programs.obsidian = {
    enable = mkEnableOption "Enable programs.obsidian";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ obsidian ];
  };
}
