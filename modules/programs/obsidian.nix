{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.obsidian;
in
with lib;
{
  options.modules.programs.obsidian = {
    enable = mkEnableOption "Enable programs.obsidian";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ obsidian ];
  };
}
