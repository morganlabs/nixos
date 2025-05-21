{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.config.cmdbar-always-visible;
in
{
  options.modules.programs.nvim.config.cmdbar-always-visible = {
    enable = mkEnableOption "Enable programs.nvim.config.cmdbar-always-visible";
  };

  config = mkIf (!cfg.enable) {
    programs.nixvim.opts.cmdheight = mkForce 0;
  };
}
