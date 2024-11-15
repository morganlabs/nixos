{ ... }: {
  homeManagerModules = {
    desktop.hyprland.enable = true;

    programs = {
      git.enable = true;
    };
  };

  home.stateVersion = "24.05";
}
