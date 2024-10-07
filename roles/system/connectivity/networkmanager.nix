{ config, lib, ... }:
with lib;
let
  cfg = config.roles.connectivity.networkmanager;
in
{
  options.roles.connectivity.networkmanager = {
    enable = mkEnableOption "NetworkManager";
  };

  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
  };
}
