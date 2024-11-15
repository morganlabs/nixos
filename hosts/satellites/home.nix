{ ... }: {
  homeManagerModules = {
    programs = {
      git.enable = true;
    };
  };

  home.stateVersion = "24.05";
}
