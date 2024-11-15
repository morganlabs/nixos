{ ... }:
{
  homeManagerModules = {
    base.xdgUserDirs.enable = true;
    desktop.hyprland.enable = true;

    programs = {
      firefox.enable = true;
      git.enable = true;
      kitty.enable = true;
      nvim.enable = true;
      zsh.enable = true;
      pfetch.enable = true;
      bat.enable = true;
      btop.enable = true;
      eza.enable = true;
      fzf.enable = true;
    };
  };

  home.stateVersion = "24.05";
}
