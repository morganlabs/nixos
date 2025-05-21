{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.config.line-numbers;
in
{
  options.modules.programs.nvim.config.line-numbers = {
    enable = mkEnableOption "Enable programs.nvim.config.line-numbers";
  };

  config = mkIf cfg.enable {
    programs.nixvim.opts = {
      nu = mkForce true;
      rnu = mkForce true;
    };
  };
}
