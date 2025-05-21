{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.lint.deadnix;
in
{
  options.modules.programs.nvim.plugins.lint.deadnix = {
    enable = mkEnableOption "Enable programs.nvim.plugins.lint.deadnix";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPackages = with pkgs; [ deadnix ];

      plugins.lint.lintersByFt.nix = [
        "deadnix"
        "nix"
      ];
    };
  };
}
