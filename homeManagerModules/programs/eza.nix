{
  config,
  lib,
  osConfig,
  ...
}:
let
  cfg = config.homeManagerModules.programs.eza;
in
with lib;
{
  options.homeManagerModules.programs.eza = {
    enable = mkEnableOption "Enable programs.eza";
  };

  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;
      git = true;
      colors = "auto";
      icons = "auto";
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
