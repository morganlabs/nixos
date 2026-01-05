{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.autocmds.highlight-on-yank;
in
{
  options.modules.programs.nvim.autocmds.highlight-on-yank = {
    enable = mkEnableOption "Enable programs.nvim.autocmds.highlight-on-yank";
  };

  config = mkIf cfg.enable {
    programs.nixvim.autoCmd = mkAfter [{
      event = [ "TextYankPost" ];
      command = ''lua vim.highlight.on_yank({ higroup = "IncSearch", timeout = 100 })'';
    }];
  };
}
