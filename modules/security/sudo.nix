{
  config,
  lib,
  inputs,
  vars,
  ...
}:
let
  cfg = config.modules.security.sudo;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.security.sudo = {
    enable = mkEnableOption "Enable security.sudo";
  };

  config = mkIf cfg.enable {
    security.sudo = {
      enable = true;
      extraRules = [
        {
          users = [ "${vars.user.username}" ];
          commands = [ "ALL" ];
        }
      ];
    };
  };
}
