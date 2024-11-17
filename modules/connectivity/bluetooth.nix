{
  config,
  lib,
  inputs,
  vars,
  ...
}:
let
  cfg = config.modules.connectivity.bluetooth;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.connectivity.bluetooth = {
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
