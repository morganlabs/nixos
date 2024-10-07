{ config, lib, ... }:
with lib;
let
  cfg = config.roles.laptop.powerManagement;
in
{
  options.roles.laptop.powerManagement = {
    enable = mkEnableOption "Enable default laptop power management";

    features = {
      limitCharge = {
        enable = mkOption {
          type = types.bool;
          description = "Enable the feature to limit battery charge";
          default = true;
        };

        stopCharge = mkOption {
          type = types.int;
          description = "Set the maximum value to charge the battery to";
          default = 80;
        };

        startCharge = mkOption {
          type = types.int;
          description = "Set the amount the battery must drain to before recharging";
          default = 75;
        };
      };

      powerProfiles = {
        enable = mkOption {
          type = types.bool;
          description = "Enable power profiles";
          default = false;
        };

        # Run `tlp-stat -p` to get possible power profiles
        battery = mkOption {
          type = types.str;
          description = "Choose which power profile to use on battery";
          default = "balanced";
        };

        ac = mkOption {
          type = types.str;
          description = "Choose which power profile to use on AC";
          default = "performance";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    services = {
      thermald.enable = true;
      tlp = {
        enable = true;
        settings =
          {
            # Audio
            # Disable Audio power saving
            SOUND_POWER_SAVE_ON_AC = 0;
            SOUND_POWER_SAVE_ON_BAT = 0;
            SOUND_POWER_SAVE_CONTROLLER = "N";

            # WiFi
            # Disable WiFi power saving
            WIFI_PWR_ON_AC = "off";
            WIFI_PWR_ON_BAT = "off";

            CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
            CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

            # Disable radios on startup/shutdown
            DEVICES_TO_DISABLE_ON_STARTUP = "wwan";
            DEVICES_TO_DISABLE_ON_SHUTDOWN = "bluetooth wifi wwan";

            # Disable radios when unplugged AND the radio is not in use
            DEVICES_TO_DISABLE_ON_BAT_NOT_IN_USE = "bluetooth";

            # Automatically disable WiFi when connected to Ethernet
            DEVICES_TO_DISABLE_ON_LAN_CONNECT = "wifi";

            # Automatically enable WiFi when disconnected from Ethernet
            DEVICES_TO_ENABLE_ON_LAN_DISCONNECT = "wifi";

            USB_EXCLUDE_WWAN = 1;
          }
          // (mkIf cfg.features.powerProfiles.enable {
            PLATFORM_PROFILE_ON_AC = cfg.features.powerProfiles.ac;
            PLATFORM_PROFILE_ON_BAT = cfg.features.powerProfiles.battery;
          })
          // (mkIf cfg.features.limitCharge.enable {
            STOP_CHARGE_THRESH_BAT0 = cfg.features.limitCharge.stopCharge;
            START_CHARGE_THRESH_BAT0 = cfg.features.limitCharge.startCharge;
          });
      };
    };
  };
}
