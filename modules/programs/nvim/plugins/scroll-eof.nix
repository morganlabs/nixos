{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.scroll-eof;
in
{
  options.modules.programs.nvim.plugins.scroll-eof = {
    enable = mkEnableOption "Enable programs.nvim.plugins.scroll-eof";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      opts.scrolloff = mkForce 10;
      extraPlugins = [
        {
          plugin = pkgs.vimPlugins.nvim-scroll-eof;
          config = ''
            lua << EOF
              require("scrollEOF").setup({ insert_mode = true })
            EOF
          '';
        }
      ];
    };
  };
}
