{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.settings.decoration.windows.drop-shadow;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.settings.decoration.windows.drop-shadow = {
    enable = mkEnableOption "Enable desktop.hyprland.settings.decoration.windows.drop-shadow";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.decoration.shadow =
      {
        enabled = mkForce true;
        range = mkForce 0;
        offset = mkForce "4 4";
      };
  };
}
