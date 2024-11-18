{
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        ts_ls.enable = true;
        bashls.enable = true;
        nixd.enable = true;
      };

      keymaps = {
        diagnostic."<leader>vd" = "open_float";
        lspBuf = {
          "gd" = "definition";
          "K" = "hover";
          "<leader>ca" = "code_action";
          "<leader>rn" = "rename";
          "<leader>re" = "references";
        };
      };
    };

    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";

        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "path"; }
          { name = "buffer"; }
        ];

        mapping = {
          "<C-j>" = "cmp.mapping.select_next_item(cmp_select)";
          "<C-k>" = "cmp.mapping.select_prev_item(cmp_select)";
          "<S-Tab>" = "cmp.mapping.confirm({ select = true })";
          "<C-Space>" = "cmp.mapping.complete()";
        };

        formatting = {
          fields = [
            "kind"
            "abbr"
            "menu"
          ];

          format = ''
            function(_, vim_item)
              local kind_icons = {
              	Text = "",
              	Method = "󰆧",
              	Function = "󰊕",
              	Constructor = "",
              	Field = "󰇽",
              	Variable = "󰂡",
              	Class = "󰠱",
              	Interface = "",
              	Module = "",
              	Property = "󰜢",
              	Unit = "",
              	Value = "󰎠",
              	Enum = "",
              	Keyword = "󰌋",
              	Snippet = "",
              	Color = "󰏘",
              	File = "󰈙",
              	Reference = "",
              	Folder = "󰉋",
              	EnumMember = "",
              	Constant = "󰏿",
              	Struct = "",
              	Event = "",
              	Operator = "󰆕",
              	TypeParameter = "󰅲",
              }

              local kind = vim_item.kind
              vim_item.kind = (kind_icons[kind] or "?") .. " "
              vim_item.menu = " (" .. kind .. ")"
              return vim_item
            end
          '';
        };
      };
    };
  };
}
