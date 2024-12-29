{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.kitty;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.kitty = {
    enable = mkEnableOption "Enable programs.kitty";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      stylix.targets.kitty.enable = true;
      programs.kitty = {
        enable = true;
        settings = {
          window_padding_width = 8;
          window_padding_height = 5;
          enable_audio_bell = false;
        };

        shellIntegration.enableBashIntegration = config.programs.bash.enable;
        shellIntegration.enableZshIntegration = config.programs.zsh.enable;
        shellIntegration.enableFishIntegration = config.programs.fish.enable;
      };

      wayland.windowManager.hyprland.settings = mkIf cfg.features.hyprland.enable {
        exec-once = [ "[workspace 1 silent] ${pkgs.kitty}/bin/kitty" ];
        windowrulev2 = [ "workspace 1, class:(kitty), floating:0" ];
        bind = [ "$mod, Return, exec, ${pkgs.kitty}/bin/kitty" ];
      };
    };
  };
}
