{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.config.keymaps.centred-search-cursor;
in
{
  options.modules.programs.nvim.config.keymaps.centred-search-cursor = {
    enable = mkEnableOption "Enable programs.nvim.config.keymaps.centred-search-cursor";
  };

  config = mkIf cfg.enable {
    programs.nixvim.keymaps =
      with lib.nixvim;
      mkAfter [
        (mkKeymap "n" "n" "nzzzv")
        (mkKeymap "n" "N" "Nzzzv")
      ];
  };
}
