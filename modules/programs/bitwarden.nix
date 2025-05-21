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
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [ bitwarden ];
      sessionVariables.SSH_AUTH_SOCK = "/home/${vars.user.username}/.bitwarden-ssh-agent.sock";
    };
  };
}
