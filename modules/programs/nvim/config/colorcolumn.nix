{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.config.colorcolumn;
in
{
  options.modules.programs.nvim.config.colorcolumn = {
    enable = mkEnableOption "Enable programs.nvim.config.colorcolumn";
    width = mkIntOption "The width of the color column" 80;
  };

  config = mkIf cfg.enable {
    programs.nixvim.opts.colorcolumn = mkForce (toString cfg.width);
  };
}
