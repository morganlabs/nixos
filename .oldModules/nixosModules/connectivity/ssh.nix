{
  config,
  lib,
  vars,
  ...
}:
let
  cfg = config.nixosModules.connectivity.ssh;
in
with lib;
{
  options.nixosModules.connectivity.ssh = {
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
