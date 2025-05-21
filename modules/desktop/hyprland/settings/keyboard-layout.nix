{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.settings.keyboard-layout;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.settings.keyboard-layout = {
    enable = mkEnableOption "Enable desktop.hyprland.settings.keyboard-layout";
    layout = mkStringOption "Which keyboard layout to use" "gb";
    capsIsEscape.enable = mkBoolOption "Make the Caps key act as an escape key" true;
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.input = {
      kb_layout = mkForce cfg.layout;
      kb_options = mkIfStr cfg.capsIsEscape.enable (mkBefore "caps:escape");
    };
  };
}
