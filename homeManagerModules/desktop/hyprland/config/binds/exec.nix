cfg: { config, lib, pkgs, ... }:
let
  hmModules = config.homeManagerModules;
in
with lib;
{
  wayland.windowManager.hyprland.settings.bind = [
    (mkIf hmModules.kitty.enable "$mod, Return, exec, ${pkgs.kitty}")
  ];
}
