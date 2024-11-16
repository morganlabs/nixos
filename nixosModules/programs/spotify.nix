{
  config,
  lib,
  pkgs,
  vars,
  inputs,
  ...
}:
let
  cfg = config.nixosModules.programs.spotify;
in
with lib;
{
  options.nixosModules.programs.spotify = {
    enable = mkEnableOption "Enable programs.spotify";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  imports = [ inputs.home-manager.nixosModules.home-manager ];

  config = mkIf cfg.enable {
    stylix.targets.spicetify.enable = true;
    programs.spicetify.enable = true;
    networking.firewall.allowedUDPPorts = [ 5353 ]; # Fix Spotify Connect & Google Cast

    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings =
      mkIf cfg.features.hyprland.enable
        {
          exec-once = [ "[workspace special:1 silent] ${pkgs.spotify}/bin/spotify" ];
          windowrulev2 = [ "workspace special:1, class:(spotify)" ];
        };
  };
}
