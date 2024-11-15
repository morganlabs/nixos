{ ... }: {
  homeManagerModules = {
    desktop.hyprland.enable = true;

    programs = {
      git.enable = true;
      kitty.enable = true;
    };
  };

  home.stateVersion = "24.05";
}
