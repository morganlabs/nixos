{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.lsp;
in
{
  imports = [
    ./nixd.nix
    ./ts_ls.nix
    ./bashls.nix
    ./gdscript.nix
  ];

  options.modules.programs.nvim.plugins.lsp = {
    enable = mkEnableOption "Enable programs.nvim.plugins.lsp";
  };

  config = mkIf cfg.enable {
    modules.programs.nvim.plugins.lsp = {
      nixd.enable = mkDefault true;
      ts_ls.enable = mkDefault true;
      bashls.enable = mkDefault true;
      gdscript.enable = mkDefault true;
    };

    programs.nixvim.plugins = {
      lsp = {
        enable = mkForce true;
        inlayHints = mkForce true;

        keymaps = {
          diagnostic."<leader>vd" = mkForce "open_float";
          lspBuf = {
            "gd" = mkForce "definition";
            "K" = mkForce "hover";
            "<leader>ca" = mkForce "code_action";
            "<leader>rn" = mkForce "rename";
            "<leader>re" = mkForce "references";
          };
        };
      };

      cmp = {
        enable = mkForce true;
        autoEnableSources = mkForce true;
        settings = {
          snippet.expand = mkForce "function(args) require('luasnip').lsp_expand(args.body) end";

          sources = mkBefore [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];

          mapping = {
            "<C-j>" = mkForce "cmp.mapping.select_next_item(cmp_select)";
            "<C-k>" = mkForce "cmp.mapping.select_prev_item(cmp_select)";
            "<S-Tab>" = mkForce "cmp.mapping.confirm({ select = true })";
            "<C-Space>" = mkForce "cmp.mapping.complete()";
          };

          formatting = {
            fields = mkForce [
              "kind"
              "abbr"
              "menu"
            ];

            format = mkForce ''
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
  };
}
