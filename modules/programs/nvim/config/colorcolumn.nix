{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.config.colorcolumn;
in
{
  options.modules.programs.nvim.config.colorcolumn = {
    enable = mkEnableOption "Enable programs.nvim.config.colorcolumn";
  };

  config = mkIf cfg.enable {
    programs.nixvim.opts.colorcolumn = mkForce "80";
  };
}
