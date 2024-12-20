{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.waybar;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.waybar = {
    enable = mkEnableOption "Enable programs.waybar";
    features.autostart.hyprland.enable = mkBoolOption "Autostart on Hyprland" true;

    modules = {
      clock.enable = mkBoolOption "Enable the clock module" true;
      backlight.enable = mkBoolOption "Enable the backlight module" false;
      network.enable = mkBoolOption "Enable the network module" config.networking.networkmanager.enable;
      pulseaudio.enable = mkBoolOption "Enable the pulseaudio module" config.services.pipewire.pulse.enable;
      tray.enable = mkBoolOption "Enable the tray module" true;
      workspaces.enable = mkBoolOption "Enable the Hyprland workspaces module" config.modules.desktop.hyprland.enable;
      window.enable = mkBoolOption "Enable the Hyprland window title module" config.modules.desktop.hyprland.enable;

      battery = {
        enable = mkBoolOption "Enable the battery module" false;
        bat = mkStrOption "Which battery to monitor" "";
      };

      bluetooth = {
        enable = mkBoolOption "Enable the bluetooth module" config.hardware.bluetooth.enable;
        controller = mkStrOption "WHich bluetooth controller to use" "";
      };
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      imports = [ (import ./bar.nix cfg) ];

      wayland.windowManager.hyprland.settings.exec-once =
        mkIfList cfg.features.autostart.hyprland.enable
          [ "${pkgs.waybar}/bin/waybar" ];

      stylix.targets.waybar.enable = true;
      programs.waybar = {
        enable = true;
        style = with config.stylix.base16Scheme; ''
          * {
            color: #${base04};
          }

          .modules-center * .module,
          .modules-right * .module {
            margin: 0 8px;
          }

          .modules-left #workspaces {
            margin-right: 8px;
          }

          .modules-left #workspaces button.active.visible.hosting-monitor.flat {
            border: none;
            border-radius: 0;
            background-color: #${base0E};
          }

          .modules-left #workspaces button.active.visible.hosting-monitor.flat * {
            color: #${base00};
          }

          #window {
            padding: 0 16px;
          }
        '';
      };
    };
  };
}
