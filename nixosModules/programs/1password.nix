{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
let
  cfg = config.nixosModules.programs._1password;
in
with lib;
{
  options.nixosModules.programs._1password = {
    enable = mkEnableOption "Enable programs._1password";
  };

  config = mkIf cfg.enable {
    nixosModules.security.gnome-keyring.enable = mkForce true;

    programs = {
      _1password.enable = true;
      _1password-gui = {
        enable = true;
        polkitPolicyOwners = [ vars.user.username ];
      };
    };
  };
}
