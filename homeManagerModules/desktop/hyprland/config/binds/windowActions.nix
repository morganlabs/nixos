{ config, lib, ... }:
with lib;
{
  wayland.windowManager.hyprland.settings = {
    bind = [
      # Window Actions 
      "$mod Shift, Q, killactive,"
      "$mod Shift, Space, togglefloating,"
      "$mod, F, fullscreen, 1" # Maximize
      "$mod Shift, F, fullscreen, 0" # Fullscreen

      ## Move Focus
      ### Mod+{LRUD}
      "$mod, left, movefocus, l"
      "$mod, right, movefocus, r"
      "$mod, up, movefocus, u"
      "$mod, down, movefocus, d"

      ### Mod+{HJKL}
      "$mod, h, movefocus, l"
      "$mod, j, movefocus, r"
      "$mod, k, movefocus, u"
      "$mod, l, movefocus, d"

      ## Move Window
      ### Mod+{LRUD}
      "$mod Shift, left, movewindow, l"
      "$mod Shift, right, movewindow, r"
      "$mod Shift, up, movewindow, u"
      "$mod Shift, down, movewindow, d"

      ### Mod+{HJKL}
      "$mod Shift, h, movewindow, l"
      "$mod Shift, j, movewindow, r"
      "$mod Shift, k, movewindow, u"
      "$mod Shift, l, movewindow, d"

      ## Move window to workspace
      "$mod Shift, 1, movetoworkspace, 1"
      "$mod Shift, 2, movetoworkspace, 2"
      "$mod Shift, 3, movetoworkspace, 3"
      "$mod Shift, 4, movetoworkspace, 4"
      "$mod Shift, 5, movetoworkspace, 5"
      "$mod Shift, 6, movetoworkspace, 6"
      "$mod Shift, 7, movetoworkspace, 7"
      "$mod Shift, 8, movetoworkspace, 8"
      "$mod Shift, 9, movetoworkspace, 9"
      "$mod Shift, 0, movetoworkspace, 10"
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, movewindow"
    ];
  };
}
