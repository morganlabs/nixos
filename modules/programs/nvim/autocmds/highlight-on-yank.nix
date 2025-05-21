{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.config.autocmds.highlight-on-yank;
in
{
  options.modules.programs.nvim.config.autocmds.highlight-on-yank = {
    enable = mkEnableOption "Enable programs.nvim.config.autocmds.highlight-on-yank";
  };

  config = mkIf cfg.enable {
    programs.nixvim.autoCmd = mkOrder 1 [
      {
        event = [ "TextYankPost" ];
        command = ''lua vim.highlight.on_yank({ higroup = "IncSearch", timeout = 100 })'';
      }
    ];
  };
}
