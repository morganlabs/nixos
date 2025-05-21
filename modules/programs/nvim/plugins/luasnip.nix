{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.luasnip;
  inherit (config.lib) nixvim;
in
{
  options.modules.programs.nvim.plugins.luasnip = {
    enable = mkEnableOption "Enable programs.nvim.plugins.luasnip";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPackages = with pkgs; [ luajitPackages.jsregexp ];
      plugins.luasnip.enable = mkForce true;
    };
  };
}
