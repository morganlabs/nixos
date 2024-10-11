{ pkgs }:
''
  #!/bin/bash
  sleep 1
  pkill xdg-desktop-portal-hyprland
  pkill xdg-desktop-portal-wlr
  pkill xdg-desktop-portal
  ${pkgs.xdg-desktop-portal-hyprland}/libexec/xdg-desktop-portal-hyprland &
  sleep 2
  ${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal &
''
