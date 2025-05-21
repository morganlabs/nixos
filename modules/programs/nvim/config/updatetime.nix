{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.config.updatetime;
in
{
  options.modules.programs.nvim.config.updatetime = {
    enable = mkEnableOption "Enable programs.nvim.config.updatetime";
  };

  config = mkIf cfg.enable {
    programs.nixvim.opts.updatetime = mkForce 50;
  };
}
