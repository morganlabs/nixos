{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.lint.eslint_d;
in
{
  options.modules.programs.nvim.plugins.lint.eslint_d = {
    enable = mkEnableOption "Enable programs.nvim.plugins.lint.eslint_d";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPackages = with pkgs; [ eslint_d ];

      plugins.lint.lintersByFt = {
        javascript = [ "eslint_d" ];
        typescript = [ "eslint_d" ];
        javascriptreact = [ "eslint_d" ];
        typescriptreact = [ "eslint_d" ];
        svelte = [ "eslint_d" ];
      };
    };
  };
}
