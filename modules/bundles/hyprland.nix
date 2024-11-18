{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.modules.bundles.hyprland;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.bundles.hyprland = {
    enable = mkEnableOption "Enable bundles.hyprland";
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.hyprland.enable = mkForce true;
      programs = {
        hypridle.enable = mkDefault true;
        hyprlock.enable = mkDefault true;
        hyprpolkitagent.enable = mkDefault true;

        rofi.enable = mkDefault true;
        mako.enable = mkDefault true;
        waybar.enable = mkDefault true;
        kitty.enable = mkDefault true;
        firefox.enable = mkDefault true;
      };
    };
  };
}
