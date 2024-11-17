{ config, lib, ... }:
let
  cfg = config.homeManagerModules.programs.hypridle;
in
with lib;
{
  options.homeManagerModules.programs.hypridle = {
    enable = mkEnableOption "Enable programs.hypridle";

    timeout = {
      lock = mkIntOption "How many minutes until the device auto-locks" 5;
      sleep = mkIntOption "How many minutes until the device auto-sleeps" 10;
    };
  };

  config =
    let
      timeoutUntil = {
        lock = cfg.timeout.lock * 60;
        sleep = cfg.timeout.sleep * 60;
      };
    in
    mkIf cfg.enable {
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
              timeout = timeoutUntil.lock;
              on-timeout = "hyprlock";
            }
            {
              timeout = timeoutUntil.sleep;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
    };
}
