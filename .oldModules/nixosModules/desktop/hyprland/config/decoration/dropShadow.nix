{ lib, config, ... }:
{
  wayland.windowManager.hyprland.settings.decoration = {
    shadow = {
      enabled = true;
      range = 0;
      offset = "4 4";
    };
  };
}
