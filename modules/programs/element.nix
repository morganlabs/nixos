{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.element;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.element = {
    enable = mkEnableOption "Enable programs.element";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ element-desktop ];
    home-manager.users.${vars.user.username} = {
      wayland.windowManager.hyprland.settings = mkIf cfg.features.hyprland.enable {
        exec-once = [ "[workspace special:s1 silent] ${pkgs.element-desktop}/bin/element-desktop" ];
        windowrulev2 = [ "workspace special:s1, class:(Element)" ];
      };
    };
  };
}
