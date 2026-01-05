{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.config.keymaps.move-lines;
in
{
  options.modules.programs.nvim.config.keymaps.move-lines = {
    enable = mkEnableOption "Enable programs.nvim.config.keymaps.move-lines";
  };

  config = mkIf cfg.enable {
    programs.nixvim.keymaps = with lib.nixvim; [
      (mkKeymap "v" "J" ":m '>+1<CR>gv=gv")
      (mkKeymap "v" "K" ":m '<-2<CR>gv=gv")
    ];
  };
}
