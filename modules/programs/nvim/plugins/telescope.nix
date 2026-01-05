{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.telescope;
in
{
  options.modules.programs.nvim.plugins.telescope = {
    enable = mkEnableOption "Enable programs.nvim.plugins.telescope";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPackages = with pkgs; [ ripgrep ];
      plugins = {
        web-devicons.enable = mkForce true;

        telescope = {
          enable = mkForce true;

          keymaps = {
            "<C-g>" = {
              options.desc = mkForce "Find a specific string of text within any file.";
              action = mkForce "live_grep";
            };
          };

          settings = {
            defaults.file_ignore_patterns = mkForce [
              "node_modules"
              ".git"
            ];
          };

          luaConfig.pre = mkForce ''
            local builtin = require("telescope.builtin")

            local is_inside_work_tree = {}

            local function is_git_repo()
              local cwd = vim.fn.getcwd()
              if is_inside_work_tree[cwd] == nil then
                vim.fn.system("git rev-parse --is-inside-work-tree")
                is_inside_work_tree[cwd] = vim.v.shell_error == 0
              end

              return is_inside_work_tree
            end

            -- Find all git files, including untracked ones, from git root
            -- If not in a git repo, find ALL files
            function Project_Files()
              local opts = { show_untracked = true }
              local cwd = vim.fn.getcwd()
              is_git_repo()

              if is_inside_work_tree[cwd] then
                builtin.git_files(opts)
              else
                builtin.find_files(opts)
              end
            end

            vim.keymap.set("n", "<C-p>", Project_Files)
          '';
        };
      };
    };
  };
}
