{
  config,
  lib,
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
    features.hyprlock.enable = mkBoolOption "Enable Hyprlock and Hypridle" true;
  };

  imports = [
    ./config/env.nix
    ./config/input.nix
    ./config/rules.nix
    ./config/autostart.nix
    ./config/decoration
    ./config/binds
  ];

  config = mkIf cfg.enable {
    stylix.targets.hyprland.enable = mkDefault true;
    home.sessionVariables.NIXOS_OZONE_WL = mkForce "1";

    homeManagerModules.programs = {
      hypridle.enable = true;
      hyprlock.enable = true;
    };

    wayland.windowManager.hyprland = {
      enable = mkForce true;
      settings = variables;
    };
  };
}
