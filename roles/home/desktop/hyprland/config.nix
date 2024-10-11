{
  config,
  cfg,
  lib,
  myLib,
  pkgs,
}:
with config.colorScheme.palette;
with lib;
with myLib;
strings.concatStrings [
  ''
    exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

    misc:background_color = rgb(${base00})
    misc:middle_click_paste = false;

    general {
      col.active_border = rgb(${base0E})
      col.inactive_border = rgb(${base01})

      resize_on_border = true
      extend_border_grab_area = true
    }

    # Autostart
    ${(concatLines cfg.features.autostart)}

    # Extra Binds
    ${(concatLines cfg.extra.binds)}
  ''
  (mkIfStr config.roles.desktop.waybar.enable ''
    exec-once = ${pkgs.waybar}/bin/waybar
  '')

  (mkIfStr cfg.features.screenshot.enable ''
    bind = ALT SHIFT, 1, exec, screenshot selection
    bind = ALT SHIFT, 2, exec, screenshot window
    bind = ALT SHIFT, 3, exec, screenshot all
  '')

  (mkIfStr cfg.features.brightness.enable ''
    bind = , XF86MonBrightnessUp, exec, brightnessctl set +5%
    bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
  '')

  (mkIfStr cfg.features.volume.enable ''
    bind = , XF86AudioRaiseVolume, exec, pamixer -i 5
    bind = , XF86AudioLowerVolume, exec, pamixer -d 5
    bind = , XF86AudioMute, exec, pamixer --toggle-mute
  '')

  (mkIfStr cfg.features.music.enable ''
    bind = , XF86AudioPrev, exec, playerctl previous
    bind = , XF86AudioNext, exec, playerctl next
    bind = , XF86AudioPlay, exec, playerctl play-pause
    bind = , XF86AudioPause, exec, playerctl play-pause
  '')
]
