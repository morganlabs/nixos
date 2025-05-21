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
  cfg = config.modules.desktop.hyprland.binds.programs.rofi;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.binds.programs.rofi = {
    enable = mkEnableOption "Enable desktop.hyprland.binds.programs.rofi";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.bind = mkAfter [
      "$mod, d, exec, ${pkgs.rofi}/bin/rofi -show drun"
    ];
  };
}
