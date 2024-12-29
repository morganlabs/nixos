{
  imports = [
    ./general.nix
    ./dropShadow.nix
    ./blur.nix
  ];

  wayland.windowManager.hyprland.settings = {
    animations.enabled = false;
    decoration.rounding = 0;

    misc = {
      disable_hyprland_logo = true;
      force_default_wallpaper = false;
      middle_click_paste = false;
    };
  };
}
