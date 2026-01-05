{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.config.keymaps.jump-page;
in
{
  options.modules.programs.nvim.config.keymaps.jump-page = {
    enable = mkEnableOption "Enable programs.nvim.config.keymaps.jump-page";
  };

  config = mkIf cfg.enable {
    programs.nixvim.keymaps = with lib.nixvim; [
      (mkKeymap "n" "<C-u>" "<C-u>zz")
      (mkKeymap "n" "<C-d>" "<C-d>zz")
    ];
  };
}
