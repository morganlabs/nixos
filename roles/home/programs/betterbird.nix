{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.roles.programs.betterbird;
in
{
  options.roles.programs.betterbird = {
    enable = mkEnableOption "Enable Betterbird";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ betterbird ];
  };
}
