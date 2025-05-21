{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.config.search.incremental-search;
in
{
  options.modules.programs.nvim.config.search.incremental-search = {
    enable = mkEnableOption "Enable programs.nvim.config.search.incremental-search";
  };

  config = mkIf cfg.enable {
    programs.nixvim.opts.incsearch = mkForce true;
  };
}
