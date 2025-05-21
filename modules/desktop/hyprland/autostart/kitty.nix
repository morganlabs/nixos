{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.autostart.kitty;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.autostart.kitty = {
    enable = mkEnableOption "Enable desktop.hyprland.autostart.kitty";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.exec-once =
      mkAfter
        [
          "[workspace 1] ${pkgs.kitty}/bin/kitty"
        ];
  };
}
