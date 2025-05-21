{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.lsp.nixd;
in
{
  options.modules.programs.nvim.plugins.lsp.nixd = {
    enable = mkEnableOption "Enable programs.nvim.plugins.lsp.nixd";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.lsp.servers.nixd.enable = mkForce true;
  };
}
