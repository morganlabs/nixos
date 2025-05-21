{ config, lib, ... }:
with lib;
let
  cfg = config.modules.connectivity.printing;
in
{
  options.modules.connectivity.printing = {
    enable = mkEnableOption "Enable connectivity.printing";
  };

  config = mkIf cfg.enable {
    services = {
      printing.enable = mkForce true;

      # Enable autodiscovery and driverless printing for supported printers
      avahi = {
        enable = mkForce true;
        nssmdns4 = mkForce true;
        openFirewall = mkForce true;
      };
    };
  };
}
