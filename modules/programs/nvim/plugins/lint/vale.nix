{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.lint.vale;
in
{
  options.modules.programs.nvim.plugins.lint.vale = {
    enable = mkEnableOption "Enable programs.nvim.plugins.lint.vale";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      extraPackages = with pkgs; [ vale ];
      plugins.lint.lintersByFt.markdown = [ "vale" ];
    };
  };
}
