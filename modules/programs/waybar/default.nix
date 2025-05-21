{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.waybar;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./modules
  ];

  options.modules.programs.waybar = {
    enable = mkEnableOption "Enable programs.waybar";
  };

  config = mkIf cfg.enable {
    modules.programs.waybar = {
      modules = {
        battery.enable = mkDefault false;
        pulse.enable = mkDefault true;
        bluetooth.enable = mkDefault true;
        network.enable = mkDefault true;
        workspaces.enable = mkDefault true;
        clock.enable = mkDefault true;
        tray.enable = mkDefault true;
        brightness.enable = mkDefault true;
      };
    };

    home-manager.users.${vars.user.username} = {
      stylix.targets.waybar = {
        enable = mkForce true;
        addCss = mkForce false;
        font = mkDefault "sansSerif";
      };

      programs.waybar = {
        enable = mkForce true;
        style = import ./style.nix;
        settings.mainBar.layer = mkForce "top";
      };
    };
  };
}
