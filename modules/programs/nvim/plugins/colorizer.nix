{
  programs.nixvim.plugins.nvim-colorizer = {
    enable = true;
    userDefaultOptions = {
      RGB = true;
      RRGGBB = true;
      names = true;
      RRGGBBAA = true;
      rgb_fn = true;
      hsl_fn = true;
      css = true;
      css_fn = true;
      mode = "background";
    };
  };
}
