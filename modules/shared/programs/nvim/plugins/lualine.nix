{
  lib,
  config,
  vars,
  isDarwin,
  ...
}:
with lib;
let
  colorscheme = mkIfElse isDarwin vars.colorscheme config.stylix.base16Scheme;
in
{
  programs.nixvim.plugins = {
    web-devicons.enable = true;
    lualine = {
      enable = true;
      settings = {
        options = {
          section_separators = "";
          component_separators = "";
        };

        sections = {
          lualine_a = [ "mode" ];
          lualine_b = [
            "branch"
            {
              __unkeyed-1.__raw = with colorscheme; ''
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
          lualine_c = [
            { __unkeyed-1.__raw = ''"filename", newfile_status = true''; }
            {
              __unkeyed-1.__raw = ''"diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = "󰝶 ", }'';
            }
            "diagnostics"
          ];

          lualine_x = [ "searchcount" ];
          lualine_y = [ "selectioncount" ];
          lualine_z = [ { __unkeyed-1.__raw = ''"datetime", style = "%H:%M"''; } ];
        };
      };
    };
  };
}
