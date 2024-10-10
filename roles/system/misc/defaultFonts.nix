{
  config,
  pkgs,
  lib,
  myLib,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.misc.defaultFonts;
in
{
  options.roles.misc.defaultFonts = {
    enable = mkEnableOption "Enable default fonts";
  };

  config = mkIf cfg.enable {
    fonts = {
      packages = with pkgs; [
        freefont_ttf
        noto-fonts-cjk-sans
        emojione

        (nerdfonts.override {
          fonts = [
            "IBMPlexMono"
          ];
        })
      ];

      fontconfig = {
        defaultFonts = {
          monospace = [ "BlexMono Nerd Font" ];
          emoji = [ "OpenMoji Color" ];
        };
      };
    };
  };
}
