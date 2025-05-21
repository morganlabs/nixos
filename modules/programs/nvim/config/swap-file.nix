{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.config.swapfile;
in
{
  options.modules.programs.nvim.config.swapfile = {
    enable = mkEnableOption "Enable programs.nvim.config.swapfile";
  };

  config = mkIf (!cfg.enable) {
    programs.nixvim.opts = {
      swapfile = mkForce false;
      backup = mkForce false;
    };
  };
}
