{
  cfg,
  lib,
  vars,
}:
with lib;
{
  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      stylix.targets.kitty.enable = true;
      wayland.windowManager.hyprland.settings = mkIf cfg.features.hyprland.enable {
        exec-once = [ "[workspace 1 silent] ${pkgs.kitty}/bin/kitty" ];
        windowrulev2 = [ "workspace 1, class:(kitty), floating:0" ];
        bind = [ "$mod, Return, exec, ${pkgs.kitty}/bin/kitty" ];
      };
    };
  };
}
