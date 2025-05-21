{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.settings.binds.basic;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.settings.binds.basic = {
    enable = mkEnableOption "Enable desktop.hyprland.settings.binds.basic";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings = {
      bind = mkBefore [
        "$mod Shift, Q, killactive"
        "$mod, F, fullscreen, 1"
        "$mod Shift, F, fullscreen, 0"

        # Move focus
        "$mod, left, movefocus, l"
        "$mod, down, movefocus, d"
        "$mod, up, movefocus, u"
        "$mod, right, movefocus, r"

        "$mod, h, movefocus, l"
        "$mod, j, movefocus, d"
        "$mod, k, movefocus, u"
        "$mod, l, movefocus, r"
      ];

      bindm = mkBefore [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      workspace = [ "f[1], gapsout:0, gapsin:0, rounding:false, bordersize:0" ];
    };
  };
}
