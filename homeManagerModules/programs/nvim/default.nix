{
  config,
  pkgs,
  lib,
  vars,
  ...
}:
with lib;
let
  cfg = config.homeManagerModules.programs.nvim;
  allPluginConfigs = import ./plugins { inherit config pkgs lib; };
in
{
  options.homeManagerModules.programs.nvim = {
    enable = mkEnableOption "Enable programs.nvim";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      home = {
        packages = with pkgs; [ wl-clipboard ];
        sessionVariables.EDITOR = "nvim";
      };

      stylix.targets.nixvim = {
        enable = true;
        transparentBackground = {
          main = true;
          signColumn = true;
        };
      };

      programs.nixvim = {
        enable = true;
        extraPackages = with pkgs; [ ripgrep ];
        viAlias = true;
        vimAlias = true;
        opts = import ./config/opts.nix config.lib;
        globals = import ./config/globals.nix;
        keymaps = import ./config/keymaps.nix;
        highlightOverride = import ./config/highlightOverrides.nix;
        autoCmd = import ./autoCmds;

        plugins.lazy.enable = true;

        # plugins = {
        #   hardtime.enable = true;
        #   nvim-autopairs.enable = true;
        #   web-devicons.enable = true;
        # };
      };
    }
    allPluginConfigs
  ]);
}
