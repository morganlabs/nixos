{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.config.search.highlight;
in
{
  options.modules.programs.nvim.config.search.highlight = {
    enable = mkEnableOption "Enable programs.nvim.config.search.highlight";
  };

  config = mkIf cfg.enable {
    programs.nixvim.opts.hlsearch = mkForce true;
  };
}
