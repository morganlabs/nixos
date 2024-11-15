{
  config,
  lib,
  pkgs,
  ...
}:
let
  hmModules = config.homeManagerModules;
in
with lib;
{
  wayland.windowManager.hyprland.settings.bind = [
    (mkIfStr hmModules.programs.kitty.enable "$mod, Return, exec, ${pkgs.kitty}/bin/kitty")
  ];
}
