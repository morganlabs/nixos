{
  pkgs,
  lib,
  nixvim,
  ...
}:
with lib.nvim;
{
  programs.nixvim = {
    extraPackages = with pkgs; [
      nixfmt-rfc-style
      stylua
      prettierd
      eslint_d
      beautysh
      rustfmt
      yamlfix
      rubyPackages.htmlbeautifier
    ];

    plugins.lazy.plugins = [
      {
        name = "conform";
        pkg = pkgs.vimPlugins.conform-nvim;
        event = [ "BufWritePre" ];
        cmd = [ "ConformInfo" ];
        keys = mkLazyKeys {
          "<leader>f" = ''
            mode = "",
            desc = "Format buffer",
            function()
              require("conform").format({ async = true })
            end'';
        };
        opts = {
          default_format_opts.lsp_format = "fallback";
          format_on_save.timeout_ms = 500;

          formatters_by_ft = {
            svelte = [ "prettierd" ];
            astro = [ "prettierd" ];
            javascript = [ "prettierd" ];
            typescript = [ "prettierd" ];
            javascriptreact = [ "prettierd" ];
            typescriptreact = [ "prettierd" ];
            json = [ "prettierd" ];
            markdown = [ "prettierd" ];
            css = [ "prettierd" ];
            scss = [ "prettierd" ];
            lua = [ "stylua" ];
            html = [ "htmlbeautifier" ];
            bash = [ "beautysh" ];
            rust = [ "rustfmt" ];
            yaml = [ "yamlfix" ];
            nix = [ "nixfmt" ];
          };
        };
      }
    ];
  };
}
