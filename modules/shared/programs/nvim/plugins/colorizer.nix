{
  programs.nixvim.plugins.colorizer = {
    enable = true;
    settings.user_default_options = {
      RGB = true;
      RRGGBB = true;
      names = true;
      RRGGBBAA = true;
      rgb_fn = true;
      hsl_fn = true;
    };
  };
}
