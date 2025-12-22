{ config, lib, ... }:
with lib;
let
  cfg = config.modules.services.ssh.endlessh;
in
{
  options.modules.services.ssh.endlessh = {
    enable = mkEnableOption "Enable services.ssh.endlessh";
  };

  config = mkIf cfg.enable {
    services.endlessh = {
      enable = mkForce true;
      port = mkForce 22;
      openFirewall = mkForce true;
    };
  };
}
