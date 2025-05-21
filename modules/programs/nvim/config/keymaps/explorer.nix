{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.config.keymaps.explorer;
in
{
  options.modules.programs.nvim.config.keymaps.explorer = {
    enable = mkEnableOption "Enable programs.nvim.config.keymaps.explorer";
  };

  config = mkIf cfg.enable {
    programs.nixvim.keymaps = with lib.nixvim; mkAfter [ (mkKeymap "n" "<leader>d" "<cmd>Ex<CR>") ];
  };
}
