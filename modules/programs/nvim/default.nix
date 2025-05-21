{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim;
in
{
  imports = [
    inputs.nixvim.nixosModules.nixvim
    ./plugins
    ./autocmds
    ./config
  ];

  options.modules.programs.nvim = {
    enable = mkEnableOption "Enable programs.nvim";
  };

  config = mkIf cfg.enable {
    environment.sessionVariables.EDITOR = mkForce "nvim";

    stylix.targets.nixvim = {
      enable = mkForce true;
      transparentBackground = {
        main = mkForce true;
        signColumn = mkForce true;
      };
    };

    modules.programs.nvim = {
      config = {
        autocmds.highlight-on-yank.enable = mkDefault true;

        nerd-font.enable = mkDefault true;
        line-wrap.enable = mkDefault false;
        line-numbers.enable = mkDefault true;
        tabstop.enable = mkDefault true;
        swapfile.enable = mkDefault false;
        undo-dir.enable = mkDefault true;
        termguicolors.enable = mkDefault true;
        signcolumn.enable = mkDefault true;
        updatetime.enable = mkDefault true;
        colorcolumn.enable = mkDefault true;
        cmdbar-always-visible.enable = mkDefault false;

        search = {
          ignore-case.enable = mkDefault true;
          smart-case.enable = mkDefault true;
          highlight.enable = mkDefault true;
          incremental-search.enable = mkDefault true;
        };

        keymaps = {
          leader.enable = mkDefault true;
          explorer.enable = mkDefault true;
          move-lines.enable = mkDefault true;
          system-clipboard.enable = mkDefault true;
          append-line.enable = mkDefault true;
          jump-page.enable = mkDefault true;
          centred-search-cursor.enable = mkDefault true;
          replace-word.enable = mkDefault true;
          make-file-exe.enable = mkDefault true;
        };
      };

      plugins = {
        autopairs.enable = mkDefault true;
        colorizer.enable = mkDefault true;
        conform.enable = mkDefault true;
        harpoon.enable = mkDefault true;
        lint.enable = mkDefault true;
        lsp.enable = mkDefault true;
        lualine.enable = mkDefault true;
        luasnip.enable = mkDefault true;
        scroll-eof.enable = mkDefault true;
        telescope.enable = mkDefault true;
        treesitter.enable = mkDefault true;
        indent-blankline.enable = mkDefault true;
      };
    };

    programs.nixvim = {
      enable = mkForce true;
      viAlias = mkForce true;
      vimAlias = mkForce true;

      extraPackages = with pkgs; [
        wl-clipboard
        ripgrep
      ];
    };
  };
}
