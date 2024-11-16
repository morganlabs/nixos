{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homeManagerModules.programs.signal;
in
with lib;
{
  options.homeManagerModules.programs.signal = {
    enable = mkEnableOption "Enable programs.signal";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ signal-desktop ];
    wayland.windowManager.hyprland.settings = mkIf cfg.features.hyprland.enable {
      exec-once = [ "[workspace special:2 silent] ${pkgs.signal-desktop}/bin/signal-desktop" ];
      windowrulev2 = [ "workspace special:2, class:(signal)" ];
    };
  };
}
