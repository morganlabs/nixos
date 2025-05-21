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
  cfg = config.modules.desktop.hyprland.autostart.obsidian;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.autostart.obsidian = {
    enable = mkEnableOption "Enable desktop.hyprland.autostart.obsidian";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.exec-once =
      mkAfter
        [ "[workspace 3] ${pkgs.obsidian}/bin/obsidian" ];
  };
}
