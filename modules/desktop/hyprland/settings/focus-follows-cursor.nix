{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.settings.focus-follows-cursor;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.settings.focus-follows-cursor = {
    enable = mkEnableOption "Enable desktop.hyprland.settings.focus-follows-cursor";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.input.follow_mouse =
      mkForce true;
  };
}
