{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.roles.eza;
in
{
  options.roles.eza = {
    enable = mkEnableOption "Enable Eza";
  };

  config = mkIf cfg.enable {
    programs.eza = {
      enable = true;
      enableZshIntegration = true;
      git = true;
      icons = true;
      extraOptions = [
	"-b" "-h"
        "--long" "--all" "--group-directories-first"
      ];
    };
  };
}
