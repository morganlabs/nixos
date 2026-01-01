{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.lint;
in
{
  options.modules.programs.nvim.plugins.lint = {
    enable = mkEnableOption "Enable programs.nvim.plugins.lint";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.lint = {
      enable = mkForce true;

      autoCmd = {
        event = mkForce "BufWritePost";
        callback.__raw = ''
          function()
            require("lint").try_lint()
          end
        '';
      };
    };
  };
}
