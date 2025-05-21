{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.settings.natural-scroll;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.settings.natural-scroll = {
    mouse.enable = mkBoolOption "Enable desktop.hyprland.settings.natural-scroll.mouse" false;
    touchpad.enable = mkBoolOption "Enable desktop.hyprland.settings.natural-scroll.touchpad" true;
  };

  config = {
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.input = {
      natural_scroll = cfg.mouse.enable;
      touchpad.natural_scroll = cfg.touchpad.enable;
    };
  };
}
