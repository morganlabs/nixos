{ config, lib, ... }:
with lib;
let
  cfg = config.roles.connectivity.bluetooth;
in
{
  options.roles.connectivity.bluetooth = {
    enable = mkEnableOption "Bluetooth";

    features.autostart.enable = mkOption {
      type = types.bool;
      description = "Start Bluetooth on boot";
      default = true;
    };
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = cfg.features.autostart.enable;
    };
  };
}
