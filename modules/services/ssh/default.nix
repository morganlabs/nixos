{ config, lib, ... }:
with lib;
let
  cfg = config.modules.services.ssh;

  port = 32107;
in
{
  imports = [ ./fail2ban.nix ./endlessh.nix ];

  options.modules.services.ssh = {
    enable = mkEnableOption "Enable services.ssh";
  };

  config = mkIf cfg.enable {
    modules.services.ssh = {
      fail2ban.enable = mkDefault true;
      endlessh.enable = mkDefault true;
    };

    networking.firewall.allowedTCPPorts = [ port ];
    services.openssh = {
      enable = mkForce true;
      ports = mkForce [ port ];
      settings = {
        Protocol = mkForce 2;

        ### HARDENING ###
        X11Forwarding = mkForce false;
        UseDNS = mkForce "yes";

        # Authentication & Methods
        PubkeyAuthentication = mkForce "yes";
        PasswordAuthentication = mkForce "no";
        PermitRootLogin = mkForce "no";
        IgnoreRhosts = mkForce "yes";
        MaxAuthTries = mkForce 3;
        PermitEmptyPasswords = mkForce "no";

      }
      // mkIf config.modules.services.ssh.fail2ban.enable {
        # F2B Support
        LogLevel = mkForce "VERBOSE";
      };
    };
  };
}
