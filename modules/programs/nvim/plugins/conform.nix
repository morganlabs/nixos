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
      extraPackages = with pkgs; [
        nixfmt-rfc-style
        prettierd
      ];
      plugins.conform-nvim = {
        enable = mkForce true;
        settings = {
          formatters_by_ft =
            let
              jstsConfig = {
                __unkeyed-1 = "prettierd";
                __unkeyed-2 = "prettier";
                timeout_ms = 2000;
                stop_after_first = true;
              };
            in
            {
              "_" = mkBefore [
                "squeeze_blanks"
                "trim_whitespace"
                "trim_newlines"
              ];
              nix = [ "nixfmt" ];
              javascript = jstsConfig;
              typescript = jstsConfig;
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
