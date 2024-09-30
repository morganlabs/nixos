{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.roles.defaultFonts;
in
{
  options.roles.defaultFonts = {
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
