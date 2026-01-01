{ lib, ... }:
with lib;
{
  imports = [
    ./lsp.nix
    ./conform.nix
    ./lint.nix
  ];

  modules.programs.nvim.plugins = {
    lsp.enable = mkDefault true;
    conform.enable = mkDefault true;
    lint.enable = mkDefault true;
  };
}
