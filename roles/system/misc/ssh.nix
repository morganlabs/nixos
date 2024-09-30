{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.roles.ssh;
in
{
  options.roles.ssh = {
    enable = mkEnableOption "SSH";
  };

  config = mkIf cfg.enable {
    services.openssh.enable = true;
  };
}
