{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.obsidian;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.obsidian = {
    enable = mkEnableOption "Enable programs.obsidian";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ obsidian ];
    home-manager.users.${vars.user.username} = {
      wayland.windowManager.hyprland.settings = mkIf cfg.features.hyprland.enable {
        exec-once = [ "[workspace 3 silent] ${pkgs.obsidian}/bin/obsidian" ];
        windowrulev2 = [ "workspace 3, class:(obsidian)" ];
      };
    };
  };
}
