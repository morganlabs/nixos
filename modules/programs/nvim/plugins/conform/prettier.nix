{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.conform.prettier;
in
{
  options.modules.programs.nvim.plugins.conform.prettier = {
    enable = mkEnableOption "Enable programs.nvim.plugins.conform.prettier";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPackages = with pkgs; [ nodePackages_latest.prettier ];

      plugins.conform-nvim.settings.formatters_by_ft = {
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
      };
    };
  };
}
