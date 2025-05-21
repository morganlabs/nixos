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
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} =
      { config, ... }:
      {
        home.packages = with pkgs; [ kora-icon-theme ];

        programs.rofi = {
          enable = mkForce true;
          package = mkForce pkgs.rofi-wayland;
          # theme = import ./theme.nix config;
          extraConfig = import ./config.nix;
        };
      };
  };
}
