{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.roles.firewall;
in
{
  options.roles.firewall = {
    enable = mkEnableOption "Firewall";
  };

  config = mkIf cfg.enable {
    networking.firewall.enable = true;
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
  };
}
