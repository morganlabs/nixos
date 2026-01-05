{
  config,
  lib,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs._1password;
in
{
  options.modules.programs._1password = {
    enable = mkEnableOption "Enable programs._1password";
  };

  config = mkIf cfg.enable {
    programs = {
      _1password.enable = mkForce true;
      _1password-gui = {
        enable = mkForce true;
        polkitPolicyOwners = mkForce [ vars.user.username ];
      };

      ssh.extraConfig = mkAfter ''
        Host *
          IdentityAgent ~/.1password/agent.sock
      '';
    };

    services.gnome.gnome-keyring.enable = mkForce true;
  };
}
