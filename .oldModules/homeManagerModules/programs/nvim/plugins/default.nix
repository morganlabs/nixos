{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  allPluginConfigs =
    let
      importPlugin =
        file:
        (import file {
          inherit config pkgs lib;
          inherit (config.lib) nixvim;
        });
    in
    mkMerge [
      (importPlugin ./colorizer.nix)
      (importPlugin ./conform.nix)
      (importPlugin ./harpoon.nix)
      (importPlugin ./lint.nix)
      (importPlugin ./lualine.nix)
      (importPlugin ./luasnip.nix)
      (importPlugin ./telescope.nix)
      (importPlugin ./lsp.nix)
    ];
in
allPluginConfigs
