{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.settings.decoration.blur;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.settings.decoration.blur = {
    enable = mkEnableOption "Enable desktop.hyprland.settings.decoration.blur";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.decoration.blur = {
      enabled = mkForce true;
      size = mkForce 12;
      passes = mkForce 3;
      noise = mkForce 2.5e-2;
    };
  };
}
