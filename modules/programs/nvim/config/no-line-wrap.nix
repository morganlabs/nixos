{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.config.no-line-wrap;
in
{
  options.modules.programs.nvim.config.no-line-wrap = {
    enable = mkEnableOption "Enable programs.nvim.config.no-line-wrap";
  };

  config = mkIf cfg.enable {
    programs.nixvim.opts.wrap = mkForce false;
  };
}

