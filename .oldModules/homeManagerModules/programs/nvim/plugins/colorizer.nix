{ pkgs, ... }:
{
  programs.nixvim.plugins.lazy.plugins = [
    {
      name = "nvim-colorizer";
      pkg = pkgs.vimPlugins.nvim-colorizer-lua;
      opts = {
        "*" = {
          RRGGBBAA = false;
          rgb_fn = false;
          hsl_fn = false;
          css = false;
          css_fn = false;
          mode = "background";
        };
      };
    }
  ];
}
