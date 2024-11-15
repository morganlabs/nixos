{ config, lib, osConfig, ... }:
let
  cfg = config.homeManagerModules.programs.kitty;
in
with lib;
{
  options.homeManagerModules.programs.kitty = {
    enable = mkEnableOption "Enable programs.kitty";
  };

  config = mkIf cfg.enable {
    stylix.targets.kitty.enable = true;
    programs.kitty = {
      enable = true;
      settings = {
        window_padding_width = 8;
        window_padding_height = 5;
        enable_audio_bell = false;
      };

      shellIntegration.enableBashIntegration = osConfig.programs.bash.enable;
      shellIntegration.enableZshIntegration = osConfig.programs.zsh.enable;
      shellIntegration.enableFishIntegration = osConfig.programs.fish.enable;
    };
  };
}
