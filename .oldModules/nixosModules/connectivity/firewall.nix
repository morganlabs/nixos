{ config, lib, ... }:
let
  cfg = config.nixosModules.connectivity.firewall;
in
with lib;
{
  options.nixosModules.connectivity.firewall = {
    enable = mkEnableOption "Enable connectivity.firewall";
  };

  config = mkIf cfg.enable {
    networking.firewall.enable = mkForce true;
  };
}
