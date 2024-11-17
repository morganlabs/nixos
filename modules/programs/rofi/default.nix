{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.rofi;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.rofi = {
    enable = mkEnableOption "Enable programs.rofi";
    features.binds.hyprland.enable = mkBoolOption "Enable Hyprland bind" true;
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} =
      { config, ... }:
      {
        home.packages = with pkgs; [ kora-icon-theme ];

        programs.rofi = {
          enable = true;
          package = pkgs.rofi-wayland;
          theme = import ./theme.nix { inherit config; };
          extraConfig = import ./config.nix;
        };

        wayland.windowManager.hyprland.settings.bind = mkIfList cfg.features.binds.hyprland.enable [
          "$mod, d, exec, rofi -show drun"
        ];
      };
  };
}
