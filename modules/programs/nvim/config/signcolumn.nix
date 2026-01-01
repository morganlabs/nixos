{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.config.signcolumn;
in
{
  options.modules.programs.nvim.config.signcolumn = {
    enable = mkEnableOption "Enable programs.nvim.config.signcolumn";
  };

  config = mkIf cfg.enable {
    programs.nixvim.opts.signcolumn = mkForce "yes";
  };
}
