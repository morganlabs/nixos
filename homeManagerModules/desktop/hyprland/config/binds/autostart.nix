{ config, lib, pkgs, ... }:
let
  hmModules = config.homeManagerModules;
  mkSilentWorkspace = ws: exec: "[workspace ${builtins.toString ws} silent] ${exec}";
in
with lib;
{
  wayland.windowManager.hyprland.settings.exec-once = [
    (mkIfStr hmModules.programs.kitty.enable mkSilentWorkspace 1 "${pkgs.kitty}/bin/kitty")
  ];
}
