{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.roles.programs.obsidian;
in
{
  options.roles.programs.obsidian = {
    enable = mkEnableOption "Enable obsidian";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ obsidian ];
  };
}
