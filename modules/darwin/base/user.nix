{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
let
  cfg = config.modules.base.user;
in
with lib;
{
  imports = [ inputs.home-manager.darwinModules.home-manager ];

  options.modules.base.user = {
    enable = mkEnableOption "Enable base.user";
  };

  config = mkIf cfg.enable {
    users.users.${vars.user.username} = {
      home = "/Users/${vars.user.username}";
      description = mkForce vars.user.name;
    };
  };
}

