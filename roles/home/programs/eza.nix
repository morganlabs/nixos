{
  config,
  lib,
  myLib,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.programs.eza;
in
{
  options.roles.programs.eza = {
    enable = mkEnableOption "Enable Eza";
  };

  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = true;
      extraOptions = [
        "-b"
        "-h"
        "--long"
        "--all"
        "--group-directories-first"
      ];
    };
  };
}
