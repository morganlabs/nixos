{ config, lib, ... }:
let
  cfg = config.nixosModules.connectivity.bluetooth;
in
with lib;
{
  options.nixosModules.connectivity.bluetooth = {
    enable = mkEnableOption "Enable connectivity.bluetooth";

    features = {
      blueman.enable = mkBoolOption "Enable Blueman" false;
      autostart.enable = mkBoolOption "Autostart Bluetooth" true;
    };
  };

  config = mkIf cfg.enable {
    services.blueman.enable = mkForce cfg.features.blueman.enable;

    hardware.bluetooth = {
      enable = mkForce true;
      powerOnBoot = mkForce cfg.features.autostart.enable;
    };
  };
}
