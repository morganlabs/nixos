{
  config,
  lib,
  myLib,
  pkgs,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.programs.nvim;

  toLua = str: "lua << EOF\n${str}\nEOF\n";
  toLuaFile = file: toLua (builtins.readFile file);

  luaPluginRunSetup = plugin: luaName: {
    inherit plugin;
    config = toLua ''require("${luaName}").setup()'';
  };

  luaPluginConfigFile = plugin: file: {
    inherit plugin;
    config = toLuaFile file;
  };
in
{
  options.roles.programs.nvim = {
    enable = mkEnableOption "Enable Neovim";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ ripgrep ];

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      defaultEditor = true;

      plugins = with pkgs.vimPlugins; [
        vim-nix
        nvim-web-devicons
        nvim-treesitter.withAllGrammars
        nvim-treesitter-parsers.rasi

        (luaPluginRunSetup indent-blankline-nvim "ibl")
        (luaPluginRunSetup codeium-nvim "codeium")

        (luaPluginConfigFile harpoon ./plugins/harpoon.lua)
        (luaPluginConfigFile lualine-nvim ./plugins/lualine.lua)
        (luaPluginConfigFile telescope-nvim ./plugins/telescope.lua)
        (luaPluginConfigFile scroll-eof-nvim ./plugins/scroll-eof.lua)
        (luaPluginConfigFile gruvbox-nvim ./plugins/colours.lua)
        (luaPluginConfigFile nvim-autopairs ./plugins/autopairs.lua)
        (luaPluginConfigFile nvim-colorizer-lua ./plugins/colorizer.lua)

        # LSP
        (luaPluginConfigFile lsp-zero-nvim ./plugins/lsp-zero.lua)
        nvim-cmp
        cmp-nvim-lsp
        nvim-lspconfig
        (luaPluginConfigFile conform-nvim ./plugins/conform.lua)
        (luaPluginConfigFile nvim-lint ./plugins/lint.lua)
        (luaPluginConfigFile luasnip ./plugins/luasnip.lua)
        cmp_luasnip
      ];

      extraPackages = with pkgs; [
        (python3.withPackages (
          ps: with ps; [
            black
            isort
            yamllint
            debugpy
          ]
        ))

        # Lua
        lua-language-server
        selene
        stylua

        # Nix
        nixfmt-rfc-style
        nil
        deadnix

        # Shell scripting
        bash-language-server
        shellcheck
        shellharden
        beautysh

        # JavaScript/TypeScript
        nodePackages.prettier
        # nodePackages.eslint
        eslint_d
        nodePackages.typescript-language-server

        # Rust
        rustfmt

        # HTML
        rubyPackages_3_3.htmlbeautifier

        # YAML
        yamlfix

        # Additional
        nodePackages.yaml-language-server
        nodePackages.vscode-langservers-extracted
        nodePackages.markdownlint-cli
        codespell
      ];

      extraLuaConfig = (
        strings.concatStrings [
          (builtins.readFile ./options.lua)
          (builtins.readFile ./binds.lua)
        ]
      );
    };
  };
}
