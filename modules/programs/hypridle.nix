{
  config,
  lib,
  inputs,
  vars,
  ...
}:
let
  cfg = config.modules.programs.hypridle;

  timeoutUntil = {
    lock = cfg.timeout.lock * 60;
    sleep = cfg.timeout.sleep * 60;
  };
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.hypridle = {
    enable = mkEnableOption "Enable programs.hypridle";

    timeout = {
      lock = mkIntOption "How many minutes until the device auto-locks" 5;
      sleep = mkIntOption "How many minutes until the device auto-sleeps" 10;
    };
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
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
  };
}
