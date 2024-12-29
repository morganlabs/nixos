{ pkgs, ... }:
{
  programs.nixvim.extraPlugins = [
    {
      plugin = pkgs.vimPlugins.nvim-scroll-eof;
      config = ''
        lua << EOF
          require("scrollEOF").setup({ insert_mode = true })
        EOF
      '';
    }
  ];
}
