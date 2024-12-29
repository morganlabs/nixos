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
  volume = pkgs.writeShellScriptBin "volume" (builtins.readFile ./volume.sh);
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.functions.volume = {
    enable = mkEnableOption "Enable functions.volume";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      pamixer
      volume
    ];

    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.bind =
      mkIf cfg.features.hyprland.enable
        [
          ", XF86AudioRaiseVolume, exec, ${volume}/bin/volume inc"
          ", XF86AudioLowerVolume, exec, ${volume}/bin/volume dec"
          ", XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer --toggle-mute"
        ];
  };
}
