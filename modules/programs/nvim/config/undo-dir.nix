{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.config.undo-dir;
in
{
  options.modules.programs.nvim.config.undo-dir = {
    enable = mkEnableOption "Enable programs.nvim.config.undo-dir";
  };

  config = mkIf cfg.enable {
    programs.nixvim.opts = {
      undofile = mkForce true;
      undodir = mkForce (config.lib.nixvim.mkRaw ''os.getenv("HOME") .. "/.vim/undodir"'');
    };
  };
}
