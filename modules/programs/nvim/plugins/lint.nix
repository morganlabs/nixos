{
  pkgs,
  nixvim,
  lib,
  ...
}:
with lib.nvim;
{
  programs.nixvim = {
    extraPackages = with pkgs; [
      eslint_d
      deadnix
      selene
      vale
    ];

    plugins.lazy.plugins =
      let
        events = [
          "BufRead"
          "BufWritePost"
          "InsertLeave"
        ];
      in
      [
        {
          name = "lint";
          pkg = pkgs.vimPlugins.nvim-lint;
          event = events;
          keys = mkLazyKeys {
            "<leader>l" = ''
              mode = "",
              desc = "Lint buffer",
              function()
                require("lint").try_lint()
              end'';
          };
          opts = {
            inherit events;
            linters_by_ft = {
              lua = [ "selene" ];
              markdown = [ "vale" ];
              javascript = [ "eslint_d" ];
              typescript = [ "eslint_d" ];
              javascriptreact = [ "eslint_d" ];
              typescriptreact = [ "eslint_d" ];
              svelte = [ "eslint_d" ];
              nix = [
                "deadnix"
                "nix"
              ];
            };
          };
          config = ''
               function (_, opts)
                 local lint = require("lint")
                 lint.linters_by_ft = opts.linters_by_ft

                 vim.api.nvim_create_autocmd(opts.events, {
                   group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
                   callback = function()
              lint.try_lint()
            end
                 })
               end
          '';
        }
      ];
  };
}
