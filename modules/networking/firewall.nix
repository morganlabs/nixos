{ config, lib, inputs, vars, ... }:
with lib;
let
  cfg = config.modules.networking.firewall;
in
{
  options.modules.networking.firewall = {
    enable = mkEnableOption "Enable networking.firewall";
  };

  config = mkIf cfg.enable {
    networking.firewall.enable = mkForce true;
  };
}
