{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.modules.decoration.fonts;
in
with lib;
{
  imports = [ inputs.home-manager.darwinModules.home-manager ];

  options.modules.decoration.fonts = {
    enable = mkEnableOption "Enable decoration.fonts";
  };

  config = mkIf cfg.enable {
    fonts.packages = with pkgs.nerd-fonts; [ monaspace ];
  };
}
