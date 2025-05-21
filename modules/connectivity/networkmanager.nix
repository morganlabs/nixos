{ config, lib, ... }:
with lib;
let
  cfg = config.modules.connectivity.networkmanager;
in
{
  options.modules.connectivity.networkmanager = {
    enable = mkEnableOption "Enable connectivity.networkmanager";
    wireless.enable = mkBoolOption "Enable wireless networking" false;
    firewall.enable = mkBoolOption "Enable firewall" true;
  };

  config = mkIf cfg.enable {
    networking = {
      networkmanager.enable = mkForce true;
      wireless.iwd.enable = mkForce cfg.wireless.enable;
      firewall.enable = mkForce cfg.firewall.enable;
    };
  };
}
