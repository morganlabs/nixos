{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.conform.nixfmt;
in
{
  options.modules.programs.nvim.plugins.conform.nixfmt = {
    enable = mkEnableOption "Enable programs.nvim.plugins.conform.nixfmt";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPackages = with pkgs; [ nixfmt-rfc-style ];
      plugins.conform-nvim.settings.formatters_by_ft.nix = [ "nixfmt" ];
    };
  };
}
