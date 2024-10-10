{
  config,
  lib,
  myLib,
  pkgs,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.cmd.pfetch;
in
{
  options.roles.cmd.pfetch = {
    enable = mkEnableOption "Enable pfetch";
    features.zsh.autoRun.enable = mkOptionBool "Automatically run `pfetch` when zsh starts" true;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ pfetch ];

    programs.zsh = {
      initExtra = mkIfStr cfg.features.zsh.autoRun.enable "pfetch";
      envExtra = ''
        export PF_INFO="title os kernel uptime pkgs editor wm";
        export PF_SEP=" ";
      '';
    };
  };
}
