{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  cfg = config.modules.programs.nvim;
in
with lib;
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nixvim.nixosModules.nixvim
    ./plugins
  ];

  options.modules.programs.nvim = {
    enable = mkEnableOption "Enable programs.nvim";
  };

  config = mkIf cfg.enable {
    environment = {
      sessionVariables.EDITOR = "nvim";
      systemPackages = with pkgs; [
        wl-clipboard
        ripgrep
      ];
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
      viAlias = true;
      vimAlias = true;
      opts = import ./config/opts.nix config.lib;
      globals = import ./config/globals.nix;
      keymaps = import ./config/keymaps.nix;
      highlightOverride = import ./config/highlightOverrides.nix;
      autoCmd = import ./autoCmds;

      plugins = {
        fidget.enable = true;
        indent-blankline.enable = true;
      };
    };
  };
}
