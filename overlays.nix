inputs: with inputs; [
  nur.overlays.default

  (_: prev: {
    vimPlugins = prev.vimPlugins // {
      nvim-scroll-eof = prev.vimUtils.buildVimPlugin {
        name = "nvim-scroll-eof";
        src = nvim-plugin-scroll-eof;
      };
    };
  })
]
