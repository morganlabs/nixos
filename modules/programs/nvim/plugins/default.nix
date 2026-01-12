{ lib, ... }:
with lib;
{
  imports = [
    ./luasnip
    ./autopairs.nix
    ./colorizer.nix
    ./conform.nix
    ./harpoon.nix
    ./indent-blankline.nix
    ./lint.nix
    ./lsp.nix
    ./telescope.nix
    ./tiny-inline-diagnostic.nix
    ./treesitter.nix
    ./copilot.nix
  ];

  modules.programs.nvim.plugins = {
    luasnip.enable = mkDefault true;
    autopairs.enable = mkDefault true;
    colorizer.enable = mkDefault true;
    conform.enable = mkDefault true;
    harpoon.enable = mkDefault true;
    indent-blankline.enable = mkDefault true;
    lint.enable = mkDefault true;
    lsp.enable = mkDefault true;
    telescope.enable = mkDefault true;
    tiny-inline-diagnostic.enable = mkDefault true;
    treesitter.enable = mkDefault true;
    copilot.enable = mkDefault true;
  };
}
