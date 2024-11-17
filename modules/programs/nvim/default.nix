{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.modules.programs.nvim;
  allPluginConfigs = import ./plugins { inherit config pkgs lib; };
in
with lib;
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nixvim.nixosModules.nixvim
  ];

  options.modules.programs.nvim = {
    enable = mkEnableOption "Enable programs.nvim";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      environment.sessionVariables.EDITOR = "nvim";
      environment.systemPackages = with pkgs; [
        wl-clipboard
        ripgrep
      ];

      stylix.targets.nixvim = {
        enable = true;
        transparentBackground = {
          main = true;
          signColumn = true;
        };
      };

      programs.nixvim = {
        enable = true;
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
