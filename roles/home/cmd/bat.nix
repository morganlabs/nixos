{
  config,
  lib,
  pkgs,
  user,
  ...
}:
with lib;
let
  cfg = config.roles.bat;
in
{
  options.roles.bat = {
    enable = mkEnableOption "Enable Bat";
  };

  config = mkIf cfg.enable {
    programs.bat = {
      enable = true;
      config = {
        theme = "gruvbox-dark";
	style = "numbers,changes,header";
      };
    };
  };
}
