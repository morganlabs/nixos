{
  config,
  lib,
  vars,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.tidal;
in
with lib;
{
  options.modules.programs.tidal = {
    enable = mkEnableOption "Enable programs.tidal";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  imports = [ inputs.home-manager.nixosModules.home-manager ];

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ tidal-hifi ];

    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings =
      mkIf cfg.features.hyprland.enable
        {
          exec-once = [ "[workspace special:s3 silent] tidal" ];
          windowrulev2 = [ "workspace special:s3, class:(tidal)" ];
        };
  };
}
