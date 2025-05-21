{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.settings.binds.windows.movement;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.settings.binds.windows.movement = {
    enable = mkEnableOption "Enable desktop.hyprland.settings.binds.windows.movement";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.bind = mkAfter [
      ## Move Window
      "$mod Shift, left, movewindow, l"
      "$mod Shift, right, movewindow, r"
      "$mod Shift, up, movewindow, u"
      "$mod Shift, down, movewindow, d"

      "$mod Shift, h, movewindow, l"
      "$mod Shift, j, movewindow, r"
      "$mod Shift, k, movewindow, u"
      "$mod Shift, l, movewindow, d"

      ## Move window to workspace
      "$mod Shift, 1, movetoworkspace, 1"
      "$mod Shift, 2, movetoworkspace, 2"
      "$mod Shift, 3, movetoworkspace, 3"
      "$mod Shift, 4, movetoworkspace, 4"
      "$mod Shift, 5, movetoworkspace, 5"
      "$mod Shift, 6, movetoworkspace, 6"
      "$mod Shift, 7, movetoworkspace, 7"
      "$mod Shift, 8, movetoworkspace, 8"
      "$mod Shift, 9, movetoworkspace, 9"
      "$mod Shift, 0, movetoworkspace, 10"
    ];
  };
}
