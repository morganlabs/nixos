{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.signal;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.signal = {
    enable = mkEnableOption "Enable programs.signal";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ signal-desktop ];
    home-manager.users.${vars.user.username} = {
      wayland.windowManager.hyprland.settings = mkIf cfg.features.hyprland.enable {
        exec-once = [ "[workspace special:s2 silent] ${pkgs.signal-desktop}/bin/signal-desktop" ];
        windowrulev2 = [ "workspace special:s2, class:(signal)" ];
      };
    };
  };
}
