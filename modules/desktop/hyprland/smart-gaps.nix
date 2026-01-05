{
  config,
  lib,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.smart-gaps;
in
{
  options.modules.desktop.hyprland.smart-gaps = {
    enable = mkEnableOption "Enable desktop.hyprland.smart-gaps";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      wayland.windowManager.hyprland = {
        enable = mkForce true;
        settings = {
          workspace = [
            "w[tv1], gapsout:0, gapsin:0"
            "f[1], gapsout:0, gapsin:0"
          ];
          windowrule = [
            {
              name = "no-gaps-wtv1";
              "match:float" = false;
              "match:workspace" = "w[tv1]";

              border_size = 0;
              rounding = 0;
            }
            {
              name = "no-gaps-f1";
              "match:float" = false;
              "match:workspace" = "f[1]";

              border_size = 0;
              rounding = 0;
            }
          ];
        };
      };
    };
  };
}
