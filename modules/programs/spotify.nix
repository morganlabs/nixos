{
  config,
  lib,
  vars,
  inputs,
  ...
}:
let
  cfg = config.modules.programs.spotify;
  spicetify = inputs.spicetify-nix.modules.spicetify;
in
with lib;
{
  options.modules.programs.spotify = {
    enable = mkEnableOption "Enable programs.spotify";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.spicetify-nix.nixosModules.default
  ];

  config = mkIf cfg.enable {
    stylix.targets.spicetify.enable = true;
    programs.spicetify.enable = true;
    networking.firewall.allowedUDPPorts = [ 5353 ]; # Fix Spotify Connect & Google Cast

    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings =
      mkIf cfg.features.hyprland.enable
        {
          exec-once = [ "[workspace special:s3 silent] spotify" ];
          windowrulev2 = [ "workspace special:s3, class:(spotify)" ];
        };
  };
}
