{ config, lib, ... }:
with lib;
let
  cfg = config.roles.desktop.hypridle;
in
{
  options.roles.desktop.hypridle = {
    enable = mkEnableOption "Enable Hypridle";

    timeoutUntil = {
      lock = mkOption {
        type = types.int;
        description = "How many seconds until the device auto-locks";
        default = 600;
      };
      sleep = mkOption {
        type = types.int;
        description = "How many seconds until the device auto-sleeps";
        default = 1200;
      };
    };
  };

  config = mkIf cfg.enable {
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = cfg.timeoutUntil.lock;
            on-timeout = "hyprlock";
          }
          {
            timeout = cfg.timeoutUntil.sleep;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
