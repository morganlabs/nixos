{ pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = with pkgs; [
      nixfmt-rfc-style
      nodePackages_latest.prettier
      beautysh
      gdtoolkit_4
    ];

    plugins.conform-nvim = {
      enable = true;
      settings = {
        formatters_by_ft = {
          "_" = [
            "squeeze_blanks"
            "trim_whitespace"
            "trim_newlines"
          ];
          nix = [ "nixfmt" ];
          svelte = [ "prettier" ];
          astro = [ "prettier" ];
          javascript = [ "prettier" ];
          typescript = [ "prettier" ];
          javascriptreact = [ "prettier" ];
          typescriptreact = [ "prettier" ];
          json = [ "prettier" ];
          markdown = [ "prettier" ];
          css = [ "prettier" ];
          scss = [ "prettier" ];
          bash = [ "beautysh" ];
          gdscript = [ "gdformat" ];
        };

        format_on_save = {
          lsp_format = "fallback";
          timeout_ms = 500;
        };
      };

      luaConfig.post = ''
        vim.keymap.set("n", "<leader>f", function() require("conform").format({ async = true }) end)
      '';
    };
  };
}
