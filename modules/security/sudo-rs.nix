{
  config,
  lib,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.security.sudo-rs;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.security.sudo-rs = {
    enable = mkEnableOption "Enable security.sudo-rs";
  };

  config = mkIf cfg.enable {
    security = {
      sudo.enable = mkForce false;
      sudo-rs.enable = mkForce true;
    };
  };
}
