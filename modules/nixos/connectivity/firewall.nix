{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.modules.connectivity.firewall;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.connectivity.firewall = {
    enable = mkEnableOption "Enable connectivity.firewall";
  };

  config = mkIf cfg.enable {
    networking.firewall.enable = mkForce true;
  };
}
