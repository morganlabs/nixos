{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.settings.binds.functions.volume;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.desktop.hyprland.settings.binds.functions.volume = {
    enable = mkEnableOption "Enable desktop.hyprland.settings.binds.functions.volume";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.wayland.windowManager.hyprland.settings.binde =
      let
        pamixer = "${pkgs.pamixer}/bin/pamixer";
      in
      mkAfter [
        ", XF86AudioRaiseVolume, exec, ${pamixer} -i 5"
        ", XF86AudioLowerVolume, exec, ${pamixer} -d 5"
      ];
  };
}
