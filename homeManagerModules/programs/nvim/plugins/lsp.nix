{
  pkgs,
  lib,
  nixvim,
  ...
}:
with lib.nvim;
{
  programs.nixvim.plugins.lazy.plugins = [
    {
      name = "nvim-cmp";
      pkg = pkgs.vimPlugins.nvim-cmp;

      opts = {
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
        ];
        # mapping = nixvim.mkRaw ''
        #   function()
        #     local cmp = require("cmp")
        #     return cmp.mapping.preset.insert({
        #       ["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
        #       ["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
        #       ["<S-Tab>"] = cmp.mapping.confirm({ select = true }),
        #       ["<C-Space>"] = cmp.mapping.complete(),
        #     })
        #   end
        # '';
      };

      config = ''
        function(_, opts)
          require("cmp").setup(opts)
        end
      '';
    }
    {
      name = "nvim-lspconfig";
      pkg = pkgs.vimPlugins.nvim-lspconfig;
      dependencies = with pkgs.vimPlugins; [
        cmp-nvim-lsp
        lsp-zero-nvim
      ];

      opts = { };

      config = ''
        function(_, opts)
          local lspconfig_defaults = require('lspconfig').util.default_config
          lspconfig_defaults.capabilities = vim.tbl_deep_extend(
            'force',
            lspconfig_defaults.capabilities,
            require('cmp_nvim_lsp').default_capabilities()
          )
        end
      '';

      init = ''
        function()
          local opts = { buffer = bufnr, noremap = true }
          local set = vim.keymap.set

          set("n", "gd", function() vim.lsp.buf.definition() end, opts)
          set("n", "K", function() vim.lsp.buf.hover() end, opts)
          set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts) -- Diagnostics
          set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts) -- Code Actions
          set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts) -- Rename
          set("n", "<leader>re", function() vim.lsp.buf.references() end, opts) -- References
        end
      '';
    }
  ];
}
