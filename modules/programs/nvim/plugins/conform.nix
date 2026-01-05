{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.conform;
in
{
  options.modules.programs.nvim.plugins.conform = {
    enable = mkEnableOption "Enable programs.nvim.plugins.conform";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPackages = with pkgs; [ nixfmt-rfc-style ];
      plugins.conform-nvim = {
        enable = mkForce true;
        settings = {
          formatters_by_ft = {
            "_" = mkBefore [
              "squeeze_blanks"
              "trim_whitespace"
              "trim_newlines"
            ];
            nix = [ "nixfmt" ];
          };

          format_after_save = {
            async = true;
            lsp_fallback = mkForce true;
            timeout_ms = mkDefault 500;
          };
        };
      };
    };
  };
}
