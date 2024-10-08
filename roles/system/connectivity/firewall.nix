{
  config,
  lib,
  myLib,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.connectivity.firewall;
in
{
  options.roles.connectivity.firewall = {
    enable = mkEnableOption "Firewall";
  };

  config = mkIf cfg.enable {
    networking.firewall.enable = true;
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
  };
}
