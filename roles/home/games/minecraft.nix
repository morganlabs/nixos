{
  config,
  lib,
  myLib,
  pkgs,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.games.minecraft;
in
{
  options.roles.games.minecraft = {
    enable = mkEnableOption "Enable Minecraft with the Lunar Launcher";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ lunar-client ];
  };
}
