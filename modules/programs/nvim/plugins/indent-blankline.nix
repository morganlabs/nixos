{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.indent-blankline;
in
{
  options.modules.programs.nvim.plugins.indent-blankline = {
    enable = mkEnableOption "Enable programs.nvim.plugins.indent-blankline";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.indent-blankline.enable = mkForce true;
  };
}
