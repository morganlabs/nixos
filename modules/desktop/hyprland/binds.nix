{
  vars,
  pkgs,
  inputs,
  ...
}:
{
  home-manager.users.${vars.user.username}.wayland.windowManager.hyprland = {
    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];

    settings = with pkgs; {
      "$mainMod" = "SUPER";
      "$terminal" = "${kitty}/bin/kitty";
      "$menu" = "${hyprlauncher}/bin/hyprlauncher";
      "$wpctl" = "${wireplumber}/bin/wpctl";
      "$brightnessctl" = "${brightnessctl}/bin/brightnessctl";
      "$playerctl" = "${playerctl}/bin/playerctl";

      bind = [
        "$mainMod, Return, exec, $terminal"
        "$mainMod SHIFT, Q, killactive,"
        # "$mainMod, M, exec, command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"
        # "$mainMod, E, exec, $fileManager"
        "$mainMod SHIFT, Space, togglefloating,"
        "$mainMod, Space, exec, $menu"
        "$mainMod, P, pseudo," # dwindle
        "$mainMod, J, togglesplit," # dwindle

        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"

        # Switch workspaces with mainMod + [0-5]
        "$mainMod, 1, split-workspace, 1"
        "$mainMod, 2, split-workspace, 2"
        "$mainMod, 3, split-workspace, 3"
        "$mainMod, 4, split-workspace, 4"
        "$mainMod, 5, split-workspace, 5"

        # Move active window to a workspace with mainMod + SHIFT + [0-5]
        "$mainMod SHIFT, 1, split-movetoworkspacesilent, 1"
        "$mainMod SHIFT, 2, split-movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, split-movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, split-movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, split-movetoworkspacesilent, 5"

        # "$mainMod, S, togglespecialworkspace, magic"
        # "$mainMod SHIFT, S, movetoworkspace, special:magic"

        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
      ];

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
        "SUPER_CTRL, mouse:272, resizewindow"
      ];

      # Laptop multimedia keys for volume and LCD brightness
      bindel = [
        ",XF86AudioRaiseVolume, exec, $wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, $wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, $wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, $wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, $brightnessctl -e4 -n2 set 5%+"
        ",XF86MonBrightnessDown, exec, $brightnessctl -e4 -n2 set 5%-"
        ",XF86AudioNext, exec, $playerctl next"
        ",XF86AudioPause, exec, $playerctl play-pause"
        ",XF86AudioPlay, exec, $playerctl play-pause"
        ",XF86AudioPrev, exec, $playerctl previous"
      ];

      plugin = {
        split-monitor-workspaces = {
          count = 5;
          keep_focused = 0;
          enable_notifications = 0;
          enable_persistent_workspaces = 0;

          # set this to 1 for gnome-like workspace switching
          link_monitors = 0;

          # if you want a different monitor order
          # monitor_priority = DP-1, DVI-D-1;
          #
          # # you can also set max workspaces per monitor
          # max_workspaces = DP-1, 9;
          # max_workspaces = DVI-D-1, 5;
        };
      };
    };
  };
}
