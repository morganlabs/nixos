{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.roles.kitty;
in
{
  options.roles.kitty = {
    enable = mkEnableOption "Enable Kitty";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      font.name = "BlexMono Nerd Font";
      shellIntegration.enableZshIntegration = true;
      themeFile = "gruvbox-dark";

      extraConfig = ''
        window_padding_width 8
        window_padding_height 5
      '';
    };
  };
}
