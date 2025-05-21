{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.lint.gdlint;
in
{
  options.modules.programs.nvim.plugins.lint.gdlint = {
    enable = mkEnableOption "Enable programs.nvim.plugins.lint.gdlint";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPackages = with pkgs; [ gdtoolkit_4 ];
      plugins.lint.lintersByFt.gdscript = [ "gdlint" ];
    };
  };
}
