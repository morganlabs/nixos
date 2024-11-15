{
  pkgs,
  nixvim,
  config,
  ...
}:
{
  programs.nixvim.plugins.lazy.plugins = [
    {
      name = "lualine";
      pkg = pkgs.vimPlugins.lualine-nvim;
      dependencies = with pkgs.vimPlugins; [ nvim-web-devicons ];
      opts = {
        options = {
          section_separators = "";
          component_separators = "";
          # theme = "base16";
          theme = nixvim.mkRaw ''
            function()
              local theme = require("lualine.themes.base16")
              theme.normal.c.bg = nil
              return theme
            end'';
        };
        sections = {
          lualine_a = [ "mode" ];
          lualine_b = [
            "branch"
            (
              with config.stylix.base16Scheme;
              nixvim.mkRaw ''
                {
                  "diff",
                  symbols = { added = " ", modified = "󰝶 ", removed = " " },
                  diff_color = {
                    added = { fg = "#${base0B}" },
                    modified = { fg = "#${base09}" },
                    removed = { fg = "#${base08}" },
                  },
                }
              ''
            )
          ];
          lualine_c = [
            (nixvim.mkRaw ''
              {
                "filename",
                newfile_status = true,
              }
            '')
            (nixvim.mkRaw ''
              {
                "diagnostics",
                symbols = {
                  error = " ",
                  warn = " ",
                  info = " ",
                  hint = "󰝶 ",
                },
              }
            '')
          ];

          lualine_x = [ "searchcount" ];
          lualine_y = [ "selectioncount" ];
          lualine_z = [
            (nixvim.mkRaw ''
              {
                "datetime",
                style = "%H:%M"
              }
            '')
          ];
        };
      };
    }
  ];
}
