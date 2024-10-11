{
  config,
  lib,
  myLib,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.programs.bat;
in
{
  options.roles.programs.bat = {
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
