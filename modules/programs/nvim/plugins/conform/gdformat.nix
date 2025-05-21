{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.conform.gdformat;
in
{
  options.modules.programs.nvim.plugins.conform.gdformat = {
    enable = mkEnableOption "Enable programs.nvim.plugins.conform.gdformat";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPackages = with pkgs; [ gdtoolkit_4 ];

      plugins.conform-nvim.settings.formatters_by_ft.gdscript = [ "gdformat" ];
    };
  };
}
