{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.lsp.ts_ls;
in
{
  options.modules.programs.nvim.plugins.lsp.ts_ls = {
    enable = mkEnableOption "Enable programs.nvim.plugins.lsp.ts_ls";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.lsp.servers.ts_ls.enable = mkForce true;
  };
}
