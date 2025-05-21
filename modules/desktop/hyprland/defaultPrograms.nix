{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.defaultPrograms;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.defaultPrograms = {
    enable = mkEnableOption "Enable desktop.hyprland.defaultPrograms";
  };

  config = mkIf cfg.enable {
    modules = {
      programs = {
        waybar.enable = mkForce true;
        zen-browser.enable = mkForce true;
        kitty.enable = mkForce true;
        rofi.enable = mkForce true;
        obsidian.enable = mkForce true;
        spotify.enable = mkForce true;
      };

      desktop.hyprland = {
        binds.programs = {
          kitty.enable = mkForce true;
          rofi.enable = mkForce true;
        };

        autostart = {
          waybar.enable = mkForce true;
          zen-browser.enable = mkForce true;
          kitty.enable = mkForce true;
          obsidian.enable = mkForce true;
          spotify.enable = mkForce true;
        };
      };
    };
  };
}
