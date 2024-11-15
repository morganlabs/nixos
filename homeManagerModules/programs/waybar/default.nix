{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  cfg = config.homeManagerModules.programs.waybar;
in
with lib;
{
  options.homeManagerModules.programs.waybar = {
    enable = mkEnableOption "Enable programs.waybar";
    features.autostart.hyprland.enable = mkBoolOption "Autostart on Hyprland" true;

    modules = {
      clock.enable = mkBoolOption "Enable the clock module" true;
      backlight.enable = mkBoolOption "Enable the backlight module" false;
      network.enable = mkBoolOption "Enable the network module" osConfig.networking.networkmanager.enable;
      pulseaudio.enable = mkBoolOption "Enable the pulseaudio module" osConfig.services.pipewire.pulse.enable;
      tray.enable = mkBoolOption "Enable the tray module" true;
      workspaces.enable = mkBoolOption "Enable the Hyprland workspaces module" config.homeManagerModules.desktop.hyprland.enable;
      window.enable = mkBoolOption "Enable the Hyprland window title module" config.homeManagerModules.desktop.hyprland.enable;

      battery = {
        enable = mkBoolOption "Enable the battery module" false;
        bat = mkStrOption "Which battery to monitor" "";
      };

      bluetooth = {
        enable = mkBoolOption "Enable the bluetooth module" osConfig.hardware.bluetooth.enable;
        controller = mkStrOption "WHich bluetooth controller to use" "";
      };
    };
  };

  imports = [ ./bar.nix ];

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland.settings.exec-once =
      mkIfList cfg.features.autostart.hyprland.enable
        [ "${pkgs.waybar}/bin/waybar" ];

    programs.waybar = {
      enable = true;
      style = import ./style.nix config;
    };
  };
}
