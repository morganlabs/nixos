{
  config,
  lib,
  vars,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.desktop.hyprland.cursor;
in
{
  options.modules.desktop.hyprland.cursor = {
    package = {
      hypr = mkPkgOption "The cursor package for Hyprcursor" pkgs.rose-pine-hyprcursor;
      gtk = mkPkgOption "The cursor package for gtk" pkgs.rose-pine-cursor;
    };

    name = {
      hypr = mkStringOption "The name of the cursor for Hyprcursor" "rose-pine-hyprcursor";
      gtk = mkStringOption "The name of the cursor for gtk" "Rose-Pine";
    };

    size = mkIntOption "The size of the cursor" 24;
  };

  config = {
    environment.systemPackages = with cfg.package; [
      hypr
      gtk
    ];

    home-manager.users.${vars.user.username} = {
      gtk.cursorTheme = with cfg; {
        inherit size;
        package = package.gtk;
        name = name.gtk;
      };

      wayland.windowManager.hyprland.settings.env = with cfg; [
        "XCURSOR_SIZE,${toString size}"
        "HYPRCURSOR_SIZE,${toString size}"
        "HYPRCURSOR_THEME,${name.hypr}"
      ];
    };
  };
}
