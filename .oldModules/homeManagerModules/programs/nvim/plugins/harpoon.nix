{ pkgs, lib, ... }:
with lib.nvim;
{
  programs.nixvim.plugins.lazy.plugins = [
    {
      name = "harpoon";
      pkg = pkgs.vimPlugins.harpoon;
      dependencies = with pkgs.vimPlugins; [ plenary-nvim ];
      keys = mkLazyKeys {
        "<leader>a" = ''
          mode = "",
          desc = "Mark a file",
          function()
            require("harpoon.mark").add_file()
          end'';
        "<C-y>" = ''
          mode = "",
          desc = "Toggle quick menu",
          function()
            require("harpoon.ui").toggle_quick_menu()
          end'';

        "<C-h>" = ''
          mode = "",
          desc = "Navigate to file 1",
          function()
            require("harpoon.ui").nav_file(1)
          end'';
        "<C-j>" = ''
          mode = "",
          desc = "Navigate to file 2",
          function()
            require("harpoon.ui").nav_file(2)
          end'';
        "<C-k>" = ''
          mode = "",
          desc = "Navigate to file 3",
          function()
            require("harpoon.ui").nav_file(3)
          end'';
        "<C-l>" = ''
          mode = "",
          desc = "Navigate to file 4",
          function()
            require("harpoon.ui").nav_file(4)
          end'';
      };
    }
  ];
}
