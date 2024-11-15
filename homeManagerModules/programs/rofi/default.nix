{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.homeManagerModules.programs.rofi;
in
with lib;
{
  options.homeManagerModules.programs.rofi = {
    enable = mkEnableOption "Enable programs.rofi";
    binds.hyprland.enable = mkBoolOption "Enable Hyprland bind" true;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ kora-icon-theme ];

    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      theme = import ./theme.nix { inherit config; };
      extraConfig = import ./config.nix;
    };

    wayland.windowManager.hyprland.settings.bind = [ "$mod, d, exec, rofi -show drun" ];
  };
}
