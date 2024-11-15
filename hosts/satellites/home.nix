{ ... }: {
  homeManagerModules = {
    desktop.hyprland.enable = true;

    programs = {
      firefox.enable = true;
      git.enable = true;
      kitty.enable = true;
    };
  };

  home.stateVersion = "24.05";
}
