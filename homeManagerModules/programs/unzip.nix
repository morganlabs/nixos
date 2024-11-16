{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
let
  cfg = config.homeManagerModules.programs.unzip;
in
with lib;
{
  options.homeManagerModules.programs.unzip = {
    enable = mkEnableOption "Enable programs.unzip";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ unzip ];
  };
}
