{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.autostart.waybar;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.autostart.waybar = {
    enable = mkEnableOption "Enable desktop.hyprland.autostart.waybar";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings = {
      exec-once = mkAfter [ "[workspace 1] ${pkgs.waybar}/bin/waybar" ];
      layerrule = mkAfter [ "blur, waybar" ];
    };
  };
}
