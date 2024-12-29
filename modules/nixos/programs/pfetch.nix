{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.pfetch;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.pfetch = {
    enable = mkEnableOption "Enable programs.pfetch";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [ pfetch ];
      sessionVariables = {
        PF_INFO = "title os kernel uptime pkgs editor wm";
        PF_SEP = " ";
      };
    };

    home-manager.users.${vars.user.username} = {
      programs =
        let
          posixAutorunStr = ''[[ "$IN_NIX_SHELL" == "" ]] && pfetch'';
          mkPosixAutorun = shell: mkIf config.programs.${shell}.enable posixAutorunStr;
        in
        {
          zsh.initExtra = mkPosixAutorun "zsh";
          bash.initExtra = mkPosixAutorun "bash";
        };
    };
  };
}
