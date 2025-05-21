{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.settings.decoration.windows.borders;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.settings.decoration.windows.borders = {
    enable = mkEnableOption "Enable desktop.hyprland.settings.decoration.windows.borders";
    thickness = mkIntOption "How thick the borders should be" 2;
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.general.border_size =
      mkForce cfg.thickness;
  };
}
