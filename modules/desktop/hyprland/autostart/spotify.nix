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
  cfg = config.modules.desktop.hyprland.autostart.spotify;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.autostart.spotify = {
    enable = mkEnableOption "Enable desktop.hyprland.autostart.spotify";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} =
      { config, ... }:
      {
        wayland.windowManager.hyprland.settings.exec-once = mkAfter [
          "[workspace special:s1] ${config.home.profileDirectory}/bin/spotify"
        ];
      };
  };
}
