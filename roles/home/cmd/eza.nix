{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.roles.cmd.eza;
in
{
  options.roles.cmd.eza = {
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
