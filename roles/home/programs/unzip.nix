{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.roles.programs.unzip;
in
{
  options.roles.programs.unzip = {
    enable = mkEnableOption "Enable unzip";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ unzip ];
  };
}
