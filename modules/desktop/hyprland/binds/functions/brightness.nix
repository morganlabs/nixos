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
  cfg = config.modules.desktop.hyprland.settings.binds.functions.brightness;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.settings.binds.functions.brightness = {
    enable = mkEnableOption "Enable desktop.hyprland.settings.binds.functions.brightness";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.binde =
      let
        brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
      in
      mkAfter [
        ", XF86MonBrightnessUp, exec, ${brightnessctl} s +5%"
        ", XF86MonBrightnessDown, exec, ${brightnessctl} s 5%-"
      ];
  };
}
