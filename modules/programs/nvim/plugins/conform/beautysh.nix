{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.conform.beautysh;
in
{
  options.modules.programs.nvim.plugins.conform.beautysh = {
    enable = mkEnableOption "Enable programs.nvim.plugins.conform.beautysh";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPackages = with pkgs; [ beautysh ];

      plugins.conform-nvim.settings.formatters_by_ft.bash = [ "beautysh" ];
    };
  };
}
