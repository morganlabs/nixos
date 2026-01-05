{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.config.updatetime;
in
{
  options.modules.programs.nvim.config.updatetime = {
    time = mkIntOption "How long the updatetime should be in ms" 80;
  };

  config = {
    programs.nixvim.opts.updatetime = mkForce cfg.time;
  };
}
