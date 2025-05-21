{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.lsp.bashls;
in
{
  options.modules.programs.nvim.plugins.lsp.bashls = {
    enable = mkEnableOption "Enable programs.nvim.plugins.lsp.bashls";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.lsp.servers.bashls.enable = mkForce true;
  };
}
