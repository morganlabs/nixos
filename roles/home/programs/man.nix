{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.roles.programs.man;
in
{
  options.roles.programs.man = {
    enable = mkEnableOption "Enable man";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ man ];
  };
}
