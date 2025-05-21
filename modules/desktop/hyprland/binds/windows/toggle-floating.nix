{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.settings.binds.windows.toggle-floating;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.settings.binds.windows.toggle-floating = {
    enable = mkEnableOption "Enable desktop.hyprland.settings.binds.windows.toggle-floating";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.bind = mkAfter [
      "$mod Shift, Space, togglefloating,"
    ];
  };
}
