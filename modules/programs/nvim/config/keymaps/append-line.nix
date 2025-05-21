{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.config.keymaps.append-line;
in
{
  options.modules.programs.nvim.config.keymaps.append-line = {
    enable = mkEnableOption "Enable programs.nvim.config.keymaps.append-line";
  };

  config = mkIf cfg.enable {
    programs.nixvim.keymaps = with lib.nixvim; mkAfter [ (mkKeymap "n" "J" "mzJ`z") ];
  };
}
