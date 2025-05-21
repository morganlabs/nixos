{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.connectivity.bluetooth;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.connectivity.bluetooth = {
    enable = mkEnableOption "Enable connectivity.bluetooth";
    powerOnBoot = mkBoolOption "Autostart Bluetooth" true;
  };

  config = mkIf cfg.enable {
    environment.variables.PRETTY_HOSTNAME = mkForce vars.pretty-name;
    services.blueman.enable = mkForce true;
    hardware.bluetooth = {
      enable = mkForce true;
      powerOnBoot = mkForce cfg.powerOnBoot;
    };
  };
}
