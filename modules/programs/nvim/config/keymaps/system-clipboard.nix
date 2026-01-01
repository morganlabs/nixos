{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.config.keymaps.system-clipboard;
in
{
  options.modules.programs.nvim.config.keymaps.system-clipboard = {
    enable = mkEnableOption "Enable programs.nvim.config.keymaps.system-clipboard";
  };

  config = mkIf cfg.enable {
    programs.nixvim.keymaps = with lib.nixvim; [
      (mkKeymap [ "n" "x" ] "sy" ''"+y'')
      (mkKeymap [ "n" "x" ] "sy" ''"+p'')
    ];
  };
}
