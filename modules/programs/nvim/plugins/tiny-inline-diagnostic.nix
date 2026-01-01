{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.tiny-inline-diagnostic;
in
{
  options.modules.programs.nvim.plugins.tiny-inline-diagnostic = {
    enable = mkEnableOption "Enable programs.nvim.plugins.tiny-inline-diagnostic";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.tiny-inline-diagnostic = {
      enable = mkForce true;
      settings = {
        multilines.enabled = true;
        options.use_icons_from_diagnostic = true;
      };
    };
  };
}
