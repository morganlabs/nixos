{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}:
let
  cfg = config.homeManagerModules.programs.pfetch;
in
with lib;
{
  options.homeManagerModules.programs.pfetch = {
    enable = mkEnableOption "Enable programs.pfetch";
  };
  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [ pfetch ];
      sessionVariables = {
        PF_INFO = "title os kernel uptime pkgs editor wm";
        PF_SEP = " ";
      };
    };
    programs =
      let
        posixAutorunStr = ''[[ "$IN_NIX_SHELL" == "" ]] && pfetch'';
        mkPosixAutorun = shell: mkIf osConfig.programs.${shell}.enable posixAutorunStr;
      in
      {
        zsh.initExtra = mkPosixAutorun "zsh";
        bash.initExtra = mkPosixAutorun "bash";
      };
  };
}
