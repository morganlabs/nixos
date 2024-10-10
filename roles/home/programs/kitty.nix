{
  config,
  lib,
  myLib,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.programs.kitty;
in
{
  options.roles.programs.kitty = {
    enable = mkEnableOption "Enable Kitty";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      shellIntegration.enableZshIntegration = config.roles.cmd.zsh.enable;
      font.name = "BlexMono Nerd Font";
      themeFile = "gruvbox-dark";

      extraConfig = ''
        window_padding_width 8
        window_padding_height 5
        enable_audio_bell no
      '';
    };
  };
}
