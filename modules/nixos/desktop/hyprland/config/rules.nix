{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      "suppressevent maximize, class:.*"

      # File Chooser - Floating, centred
      "float, initialTitle:(Open Files)"
      "center, initialTitle:(Open Files)"
    ];

    workspace = [
      # All special workspaces - 40px outer gaps
      "s[true], gapsout:40"

      # Maximised windows - 0px outer gaps
      "f[1], gapsout:0, bordersize:0"
    ];
  };
}
