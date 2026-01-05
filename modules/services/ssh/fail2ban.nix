{ config, lib, ... }:
with lib;
let
  cfg = config.modules.services.ssh.fail2ban;
in
{
  options.modules.services.ssh.fail2ban = {
    enable = mkEnableOption "Enable services.ssh.fail2ban";
  };

  config = mkIf cfg.enable {
    services.fail2ban = {
      enable = mkForce true;
      maxretry = mkForce 6;
      bantime = mkForce "10m";
    };
  };
}
