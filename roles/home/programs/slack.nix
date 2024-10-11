{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.roles.programs.slack;
in
{
  options.roles.programs.slack = {
    enable = mkEnableOption "Enable slack";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ slack ];
  };
}
