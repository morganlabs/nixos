{ config, lib, ... }:
let
  cfg = config.modules.programs.steam;
in
with lib;
{
  options.modules.programs.steam = {
    enable = mkEnableOption "Enable programs.steam";
  };

  config = mkIf cfg.enable {
    programs.steam = {
      enable = mkForce true;
      localNetworkGameTransfers.openFirewall = mkDefault true;
    };
  };
}
