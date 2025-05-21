{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.lualine;
  inherit (config.lib) nixvim;
in
{
  options.modules.programs.nvim.plugins.lualine = {
    enable = mkEnableOption "Enable programs.nvim.plugins.lualine";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins = {
      web-devicons.enable = mkForce true;
      lualine = {
        enable = mkForce true;
        settings = {
          options = {
            section_separators = mkForce "";
            component_separators = mkForce "";
          };

          sections = {
            lualine_a = mkForce [ "mode" ];
            lualine_b = mkForce [
              "branch"
              {
                __unkeyed-1.__raw = with config.lib.stylix.colors; ''
                  "diff",
                  symbols = { added = " ", modified = "󰝶 ", removed = " " },
                  diff_color = {
                    added = { fg = "#${base0B}" },
                    modified = { fg = "#${base09}" },
                    removed = { fg = "#${base08}" },
                  }
                '';
              }
            ];
            lualine_c = mkForce [
              { __unkeyed-1.__raw = ''"filename", newfile_status = true''; }
              {
                __unkeyed-1.__raw = ''"diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = "󰝶 ", }'';
              }
              "diagnostics"
            ];

            lualine_x = mkForce [ "searchcount" ];
            lualine_y = mkForce [ "selectioncount" ];
            lualine_z = mkForce [ { __unkeyed-1.__raw = ''"datetime", style = "%H:%M"''; } ];
          };
        };
      };
    };
  };
}
