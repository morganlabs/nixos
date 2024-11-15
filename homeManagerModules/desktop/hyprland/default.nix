{
  config,
  pkgs,
  lib,
  vars,
  osConfig,
  ...
}:
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

  imports = [
    ./config/env.nix
    ./config/input.nix
    ./config/windowRules.nix
    ./config/autostart.nix
    ./config/decoration
    ./config/binds
  ];

  config = mkIf cfg.enable {
    stylix.targets.hyprland.enable = mkDefault true;
    home.sessionVariables.NIXOS_OZONE_WL = mkForce "1";

    wayland.windowManager.hyprland = {
      enable = mkForce true;
      settings = variables;
    };
  };
}
