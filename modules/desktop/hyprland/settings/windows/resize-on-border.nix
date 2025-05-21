{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.settings.windows.resize-on-border;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.settings.windows.resize-on-border = {
    enable = mkEnableOption "Enable desktop.hyprland.settings.windows.resize-on-border";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.general = {
      resize_on_border = mkForce true;
      extend_border_grab_area = mkForce true;
    };
  };
}
