{ config, lib, ... }:
with lib;
let
  cfg = config.roles.connectivity.ssh;
in
{
  options.roles.connectivity.ssh = {
    enable = mkEnableOption "SSH";
  };

  config = mkIf cfg.enable {
    services.openssh.enable = true;
  };
}
