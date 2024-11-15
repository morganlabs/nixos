{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  hmModules = config.homeManagerModules;
  mkSilentWorkspace = ws: exec: "[workspace ${builtins.toString ws} silent] ${exec}";
  firefoxNightly = inputs.firefox-nightly.packages.${pkgs.system}.firefox-nightly-bin;
in
with lib;
{
  wayland.windowManager.hyprland.settings.exec-once = [
    (mkIfStr hmModules.programs.kitty.enable mkSilentWorkspace 1 "${pkgs.kitty}/bin/kitty")
    (mkIfStr hmModules.programs.kitty.enable mkSilentWorkspace 2
      "${firefoxNightly}/bin/firefox-nightly"
    )
  ];
}
