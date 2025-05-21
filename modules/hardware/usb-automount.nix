{ config, lib, ... }:
with lib;
let
  cfg = config.modules.hardware.usb-automount;
in
{
  options.modules.hardware.usb-automount = {
    enable = mkEnableOption "Enable hardware.usb-automount";
  };

  config = mkIf cfg.enable {
    services = {
      devmon.enable = mkForce true;
      gvfs.enable = mkForce true;
      udisks2.enable = mkForce true;
    };
  };
}
