{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homeManagerModules.programs.obsidian;
in
with lib;
{
  options.homeManagerModules.programs.obsidian = {
    enable = mkEnableOption "Enable programs.obsidian";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ obsidian ];
    wayland.windowManager.hyprland.settings = mkIf cfg.features.hyprland.enable {
      exec-once = [ "[workspace 3 silent] ${pkgs.obsidian}/bin/obsidian" ];
      windowrulev2 = [ "workspace 3, class:(obsidian)" ];
    };
  };
}
