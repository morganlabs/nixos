{ config, pkgs, lib, vars, osConfig, ... }:
let
  cfg = config.homeManagerModules.desktop.hyprland;

  variables = {
    "$mod" = "SUPER";
    "$alt" = "ALT";
  };
in
with lib;
{
  options.homeManagerModules.desktop.hyprland = {
    enable = mkEnableOption "Enable desktop.hyprland";
  };

  config = mkIf cfg.enable {
    stylix.targets.hyprland.enable = true;
    home.sessionVariables.NIXOS_OZONE_WL = "1";

    wayland.windowManager.hyprland = {
      enable = true;
    };
  };
}

