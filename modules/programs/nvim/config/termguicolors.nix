{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.config.termguicolors;
in
{
  options.modules.programs.nvim.config.termguicolors = {
    enable = mkEnableOption "Enable programs.nvim.config.termguicolors";
  };

  config = mkIf cfg.enable {
    programs.nixvim.opts.termguicolors = mkForce true;
  };
}
