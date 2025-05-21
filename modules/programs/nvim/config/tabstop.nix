{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.config.tabstop;
in
{
  options.modules.programs.nvim.config.tabstop = {
    enable = mkEnableOption "Enable programs.nvim.config.tabstop";
  };

  config = mkIf cfg.enable {
    programs.nixvim.opts = {
      tabstop = mkForce 4;
      softtabstop = mkForce 4;
      shiftwidth = mkForce 4;
      expandtab = mkForce true;
      smartindent = mkForce true;
    };
  };
}
