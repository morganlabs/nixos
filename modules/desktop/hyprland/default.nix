{
  config,
  lib,
  inputs,
  vars,
  ...
}:
let
  cfg = config.modules.desktop.hyprland;

  variables = {
    "$mod" = "SUPER";
    "$alt" = "ALT";
  };
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland = {
    enable = mkEnableOption "Enable desktop.hyprland";
    features.hyprlock.enable = mkBoolOption "Enable Hyprlock and Hypridle" true;
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = mkForce true;
      xwayland.enable = mkDefault true;
    };

    modules.programs = mkIf cfg.features.hyprlock.enable {
      hypridle.enable = true;
      hyprlock.enable = true;
    };

    home-manager.users.${vars.user.username} = {
      imports = [
        ./config/env.nix
        ./config/input.nix
        ./config/rules.nix
        ./config/decoration
        ./config/binds
      ];

      stylix.targets.hyprland.enable = mkDefault true;
      home.sessionVariables.NIXOS_OZONE_WL = mkForce "1";

      wayland.windowManager.hyprland = {
        enable = mkForce true;
        settings = variables;
      };
    };
  };
}
