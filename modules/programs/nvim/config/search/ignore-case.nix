{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.config.search.ignore-case;
in
{
  options.modules.programs.nvim.config.search.ignore-case = {
    enable = mkEnableOption "Enable programs.nvim.config.search.ignore-case";
  };

  config = mkIf cfg.enable {
    programs.nixvim.opts.ignorecase = mkForce true;
  };
}
