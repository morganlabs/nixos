{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.conform;
in
{
  imports = [
    ./nixfmt.nix
    ./beautysh.nix
    ./gdformat.nix
    ./prettier.nix
  ];

  options.modules.programs.nvim.plugins.conform = {
    enable = mkEnableOption "Enable programs.nvim.plugins.conform";
  };

  config = mkIf cfg.enable {
    modules.programs.nvim.plugins.conform = {
      nixfmt.enable = true;
      beautysh.enable = true;
      gdformat.enable = true;
      prettier.enable = true;
    };

    programs.nixvim = {
      keymaps = mkAfter [
        (nixvim.mkKeymap "n" "<leader>f" ''function() require("conform").format({ async = true }) end'')
      ];

      plugins.conform-nvim = {
        enable = mkForce true;
        settings = {
          formatters_by_ft."_" = mkBefore [
            "squeeze_blanks"
            "trim_whitespace"
            "trim_newlines"
          ];

          format_on_save = {
            lsp_format = mkDefault "fallback";
            timeout_ms = mkDefault 500;
          };
        };
      };
    };
  };
}
