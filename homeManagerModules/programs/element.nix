{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homeManagerModules.programs.element;
in
with lib;
{
  options.homeManagerModules.programs.element = {
    enable = mkEnableOption "Enable programs.element";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ element-desktop ];
    wayland.windowManager.hyprland.settings = mkIf cfg.features.hyprland.enable {
      exec-once = [ "[workspace special:1 silent] ${pkgs.element-desktop}/bin/element-desktop" ];
      windowrulev2 = [ "workspace special:1, class:(Element)" ];
    };
  };
}
