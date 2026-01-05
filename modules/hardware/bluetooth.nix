{ config, lib, ... }:
with lib;
let
  cfg = config.modules.hardware.bluetooth;
in
{
  options.modules.hardware.bluetooth = {
    enable = mkEnableOption "Enable hardware.bluetooth";
  };

  config = mkIf cfg.enable {
    hardware.bluetooth.enable = mkForce true;
  };
}
