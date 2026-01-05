{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.treesitter;
in
{
  options.modules.programs.nvim.plugins.treesitter = {
    enable = mkEnableOption "Enable programs.nvim.plugins.treesitter";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPackages = with pkgs.vimPlugins.nvim-treesitter; [ withAllGrammars ];
      plugins.treesitter = {
        enable = mkForce true;

        settings.disable_filetype = (
          mkIfList config.modules.programs.nvim.plugins.telescope.enable [ "TelescopePrompt" ]
        );
      };
    };
  };
}
