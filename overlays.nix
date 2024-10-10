{ inputs, ... }:
with inputs;
[
  nur.overlay

  (self: super: {
    vimPlugins = super.vimPlugins // {
      scroll-eof-nvim = super.vimUtils.buildVimPlugin {
        name = "scroll-eof-nvim";
        src = inputs.nvim-plugin-scroll-eof;
      };
    };
  })
]
