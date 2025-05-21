{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.config.line-wrap;
in
{
  options.modules.programs.nvim.config.line-wrap = {
    enable = mkEnableOption "Enable programs.nvim.config.line-wrap";
  };

  config = mkIf (!cfg.enable) {
    programs.nixvim.opts.wrap = mkForce false;
  };
}
