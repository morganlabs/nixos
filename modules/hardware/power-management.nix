{ config, lib, ... }:
with lib;
let
  cfg = config.modules.hardware.power-management;
in
{
  options.modules.hardware.power-management = {
    enable = mkEnableOption "Enable hardware.power-management";
    intel.enable = mkBoolOption "Enable Intel-only power management tools" false;
  };

  config = mkIf cfg.enable {
    powerManagement.enable = mkForce true;
    services.thermald.enable = mkForce cfg.intel.enable;

    services.tlp = {
      enable = mkForce true;
      settings = {
        TLP_DEFAULT_MODE = "AC";
        RESTORE_DEVICE_STATE_ON_STARTUP = 0;

        DEVICES_TO_ENABLE_ON_STARTUP = "bluetooth wifi";
        DEVICES_TO_DISABLE_ON_STARTUP = "wwan";
        DEVICES_TO_DISABLE_ON_SHUTDOWN = "bluetooth wifi wwan";

        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "balanced";

        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;

        USB_AUTOSUSPEND = 1;
        USB_EXCLUDE_BTUSB = 1;
        USB_EXCLUDE_PHONE = 1;
      };
    };
  };
}
