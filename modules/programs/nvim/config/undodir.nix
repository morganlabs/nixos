{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.config.undodir;
in
{
  options.modules.programs.nvim.config.undodir = {
    enable = mkEnableOption "Enable programs.nvim.config.undodir";
  };

  config = mkIf cfg.enable {
    programs.nixvim.opts = {
      undofile = mkForce true;
      undodir = mkForce (config.lib.nixvim.mkRaw ''os.getenv("HOME") .. "/.vim/undodir"'');
    };
  };
}
