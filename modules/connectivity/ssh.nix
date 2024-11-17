{
  config,
  lib,
  inputs,
  vars,
  ...
}:
let
  cfg = config.modules.connectivity.ssh;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.connectivity.ssh = {
    enable = mkEnableOption "Enable connectivity.ssh";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = mkForce true;
      ports = mkDefault [ vars.ssh.port ];
      settings = {
        PermitRootLogin = mkForce "no";
        PasswordAuthentication = mkDefault false;
        AllowUsers = mkDefault [ vars.user.username ];
      };
    };
  };
}
