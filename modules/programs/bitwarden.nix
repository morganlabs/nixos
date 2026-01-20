{
  config,
  lib,
  pkgs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.bitwarden;
in
{
  options.modules.programs.bitwarden = {
    enable = mkEnableOption "Enable programs.bitwarden";
    sshAgent.enable = mkEnableOption "Enable Bitwarden SSH Agent integration";
  };

  config = mkIf cfg.enable {
    modules.programs.bitwarden.sshAgent.enable = mkDefault true;

    environment.systemPackages = with pkgs; [
      bitwarden-desktop
      libsecret
    ];

    home-manager.users.${vars.user.username} =
      { config, ... }:
      {
        programs.bash.enable = true;
        home.sessionVariables = mkIf cfg.sshAgent.enable {
          SSH_AUTH_SOCK = mkForce "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
        };
      };
  };
}
