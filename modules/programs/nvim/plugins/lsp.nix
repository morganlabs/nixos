{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.lsp;
in
{
  options.modules.programs.nvim.plugins.lsp = {
    enable = mkEnableOption "Enable programs.nvim.plugins.lsp";
  };

  config = mkIf cfg.enable {
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

        servers = {
          nixd.enable = mkDefault true;
          ts_ls.enable = mkDefault true;
          jsonls.enable = mkDefault true;
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
            # TODO!: Grab from old repo
            # format = mkForce '''';
          };
        };
      };
    };
  };
}
