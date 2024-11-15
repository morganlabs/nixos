{ config, lib, ... }:
let
  cfg = config.nixosModules.desktop.hyprland;
in
with lib;
{
  options.nixosModules.desktop.hyprland = {
    enable = mkEnableOption "Enable desktop.hyprland";
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = mkForce true;
      xwayland.enable = mkDefault true;
    };
  };
}
