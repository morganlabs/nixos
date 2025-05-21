{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.config.keymaps.leader;
in
{
  options.modules.programs.nvim.config.keymaps.leader = {
    enable = mkEnableOption "Enable programs.nvim.config.keymaps.leader";
    key = mkStringOption "Which key to use as the mapleader" " ";
  };

  config = mkIf cfg.enable {
    programs.nixvim.globals = {
      mapleader = mkForce cfg.key;
      maplocalleader = mkForce cfg.key;
    };
  };
}
