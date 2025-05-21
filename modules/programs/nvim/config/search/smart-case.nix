{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.config.search.smart-case;
in
{
  options.modules.programs.nvim.config.search.smart-case = {
    enable = mkEnableOption "Enable programs.nvim.config.search.smart-case";
  };

  config = mkIf cfg.enable {
    programs.nixvim.opts.smartcase = mkForce true;
  };
}
