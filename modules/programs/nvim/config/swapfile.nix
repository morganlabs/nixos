{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.config.swapfile;
in
{
  options.modules.programs.nvim.config.swapfile = {
    enable = mkEnableOption "Enable programs.nvim.config.swapfile";
  };

  config = mkIf cfg.enable {
    programs.nixvim.opts = {
      swapfile = mkForce true;
      backup = mkForce true;
    };
  };
}
