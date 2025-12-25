{ config, lib, ... }:
with lib;
let
  cfg = config.modules.networking;
in
{
  imports = [ ./firewall.nix ];

  options.modules.networking = {
    enable = mkEnableOption "Enable networking";
  };

  config = mkIf cfg.enable {
    modules.networking.firewall.enable = mkDefault true;
    networking.networkmanager.enable = mkForce true;
  };
}
