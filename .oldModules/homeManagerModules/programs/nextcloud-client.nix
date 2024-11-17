{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.homeManagerModules.programs.nextcloud-client;
in
with lib;
{
  options.homeManagerModules.programs.nextcloud-client = {
    enable = mkEnableOption "Enable programs.nextcloud-client";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ nextcloud-client ];
    wayland.windowManager.hyprland.settings = mkIf cfg.features.hyprland.enable {
      exec-once = [ "${pkgs.nextcloud-client}/bin/nextcloud-client" ];
      windowrulev2 = [
        "pin, class:(com.nextcloud.desktopclient.nextcloud)"
        "float, class:(com.nextcloud.desktopclient.nextcloud)"
        "center, class:(com.nextcloud.desktopclient.nextcloud)"
        "stayfocused, class:(com.nextcloud.desktopclient.nextcloud)"
      ];
    };
  };
}
