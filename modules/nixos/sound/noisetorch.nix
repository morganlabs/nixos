{
  config,
  lib,
  inputs,
  pkgs,
  vars,
  ...
}:
let
  cfg = config.modules.sound.noisetorch;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.sound.noisetorch = {
    enable = mkEnableOption "Enable sound.noisetorch";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  config = mkIf cfg.enable {
    programs.noisetorch.enable = true;
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.exec-once =
      mkIf cfg.features.hyprland.enable
        [
          "${pkgs.noisetorch}/bin/noisetorch -i"
        ];
  };
}
