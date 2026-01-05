{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.config.nerd;
in
{
  options.modules.programs.nvim.config.nerd = {
    enable = mkEnableOption "Enable programs.nvim.config.nerd";
  };

  config = mkIf cfg.enable {
    programs.nixvim.globals.have_nerd_font = mkForce true;
  };
}
