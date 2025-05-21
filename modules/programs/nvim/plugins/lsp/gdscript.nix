{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.lsp.gdscript;
in
{
  options.modules.programs.nvim.plugins.lsp.gdscript = {
    enable = mkEnableOption "Enable programs.nvim.plugins.lsp.gdscript";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.lsp.servers.gdscript = {
      enable = mkForce true;
      package = mkForce null;
    };
  };
}
