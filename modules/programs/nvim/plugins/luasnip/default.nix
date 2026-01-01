{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.luasnip;
in
{
  options.modules.programs.nvim.plugins.luasnip = {
    enable = mkEnableOption "Enable programs.nvim.plugins.luasnip";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPackages = with pkgs; [ luajitPackages.jsregexp ];
      plugins.luasnip = {
        enable = mkForce true;
        # TODO!: Fix - Not working :(
        # fromVscode = [
        #   {
        #     paths = toString ./vscode;
        #   }
        # ];
      };
    };
  };
}
