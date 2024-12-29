{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.vimPlugins; [ nvim-treesitter.withAllGrammars ];
  programs.nixvim.plugins.treesitter = {
    enable = true;
    settings.disable_filetype = [ "TelescopePrompt" ];
  };
}
