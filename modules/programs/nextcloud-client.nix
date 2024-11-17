{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.nextcloud-client;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.nextcloud-client = {
    enable = mkEnableOption "Enable programs.nextcloud-client";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ nextcloud-client ];
    home-manager.users.${vars.user.username} = {
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
  };
}
