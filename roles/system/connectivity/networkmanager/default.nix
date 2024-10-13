{
  config,
  lib,
  myLib,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.connectivity.networkmanager;
in
{
  options.roles.connectivity.networkmanager = {
    enable = mkEnableOption "NetworkManager";

    features = {
      dnsAdblock.enable = mkOptionBool "Enable the DNS-Level Ad Blocker" true;
    };
  };

  config = mkIf cfg.enable {
    networking = {
      networkmanager.enable = true;
      hosts = mkIf cfg.features.dnsAdblock.enable (import ./adblock.nix);
    };
  };
}
