{ pkgs, ... }:
{
  programs.nixvim = {
    extraPackages = with pkgs; [ luajitPackages.jsregexp ];
    plugins.luasnip = {
      enable = true;

    };
  };
}
