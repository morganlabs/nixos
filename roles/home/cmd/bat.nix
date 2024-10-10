{
  config,
  lib,
  myLib,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.cmd.bat;
in
{
  options.roles.cmd.bat = {
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
