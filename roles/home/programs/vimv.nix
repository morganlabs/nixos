{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.roles.programs.vimv;
in
{
  options.roles.programs.vimv = {
    enable = mkEnableOption "Enable vimv";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ vimv ];
  };
}
