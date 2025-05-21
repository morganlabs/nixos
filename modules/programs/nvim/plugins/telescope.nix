{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.telescope;
in
{
  options.modules.programs.nvim.plugins.telescope = {
    enable = mkEnableOption "Enable programs.nvim.plugins.telescope";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.telescope = {
      enable = mkForce true;

      keymaps = {
        "<C-g>" = {
          options.desc = mkForce "Use Ripgrep across the scope.";
          action = mkForce "live_grep";
        };
      };

      settings = {
        defaults.file_ignore_patterns = mkBefore [
          "node_modules"
          ".git"
          "*-lock"
          "*.lock"
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

        vim.keymap.set("n", "<C-p>", Project_files)
      '';
    };
  };
}
