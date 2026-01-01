{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.config.tabstop;
in
{
  options.modules.programs.nvim.config.tabstop = {
    width = mkIntOption "The width of a tab" 4;
  };

  config = {
    programs.nixvim.opts = with cfg; {
      tabstop = width;
      softtabstop = width;
      shiftwidth = mkForce width;
      expandtab = mkForce true;
      smartindent = mkForce true;
    };
  };
}

