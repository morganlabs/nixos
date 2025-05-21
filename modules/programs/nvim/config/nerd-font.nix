{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.config.nerd-font;
in
{
  options.modules.programs.nvim.config.nerd-font = {
    enable = mkEnableOption "Enable programs.nvim.config.nerd-font";
  };

  config = mkIf cfg.enable {
    programs.nixvim.globals = {
      have_nerd_font = mkForce true;
    };
  };
}
