{
  config,
  pkgs,
  lib,
  vars,
  inputs,
  ...
}:
let
  cfg = config.modules.programs.steam;
in
with lib;
{
  options.modules.programs.steam = {
    enable = mkEnableOption "Enable programs.steam";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  imports = [ inputs.home-manager.nixosModules.home-manager ];

  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = mkDefault false;
      localNetworkGameTransfers.openFirewall = mkDefault true;
    };

    home-manager.users.${vars.user.username} = { };
  };
}
