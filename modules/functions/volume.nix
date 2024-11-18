{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
let
  cfg = config.modules.functions.volume;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.functions.volume = {
    enable = mkEnableOption "Enable functions.volume";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ pamixer ];
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.bind =
      mkIf cfg.features.hyprland.enable
        [
          ", XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 5"
          ", XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 5"
          ", XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer --toggle-mute"
        ];
  };
}
