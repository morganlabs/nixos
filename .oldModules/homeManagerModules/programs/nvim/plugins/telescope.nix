{
  pkgs,
  lib,
  nixvim,
  ...
}:
with lib.nvim;
{
  programs.nixvim.plugins.lazy.plugins = [
    {
      name = "telescope";
      pkg = pkgs.vimPlugins.telescope-nvim;
      keys = mkLazyKeys {
        "<C-g>" = ''
          mode = "n",
          desc = "Run Live Grep",
          function()
            require("telescope.builtin").live_grep()
          end
        '';
        "<C-p>" = ''
          mode = "n",
          desc = "List all files in a project",
          function()
            Project_files()
          end
        '';
      };

      opts = {
        defaults.file_ignore_patterns = [
          "node_modules"
          ".git"
          "*-lock"
          "*.lock"
        ];
      };

      config = nixvim.mkRaw ''
        function(_, opts)
          local builtin = require("telescope.builtin")
          require("telescope").setup(opts)

          local is_inside_work_tree = {}

          local function is_git_repo()
            local cwd = vim.fn.getcwd()
            if is_inside_work_tree[cwd] == nil then
              vim.fn.system("git rev-parse --is-inside-work-tree")
              is_inside_work_tree[cwd] = vim.v.shell_error == 0
            end

            return is_inside_work_tree
          end

          -- Find all git files (including untracked) from `.git` root,
          -- if not found, find all files
          function Project_files()
            local opts = { show_untracked = true }
            local cwd = vim.fn.getcwd()
            is_git_repo()

            if is_inside_work_tree[cwd] then
              builtin.git_files(opts)
            else
              builtin.find_files(opts)
            end
          end
        end
      '';
    }
  ];
}
