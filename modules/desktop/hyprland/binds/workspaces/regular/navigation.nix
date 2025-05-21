{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.settings.binds.workspaces.regular.navigation;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.settings.binds.workspaces.regular.navigation = {
    enable = mkEnableOption "Enable desktop.hyprland.settings.binds.workspaces.regular.navigation";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.bind = mkAfter [
      ## Switch workspaces
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod, 0, workspace, 10"
    ];
  };
}
