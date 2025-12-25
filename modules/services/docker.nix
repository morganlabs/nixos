{
  config,
  lib,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.services.docker;
in
{
  options.modules.services.docker = {
    enable = mkEnableOption "Enable services.docker";
  };

  config = mkIf cfg.enable {
    users.users.${vars.user.username}.extraGroups = mkAfter [ "docker" ];

    virtualisation.docker.enable = mkForce true;
  };
}
