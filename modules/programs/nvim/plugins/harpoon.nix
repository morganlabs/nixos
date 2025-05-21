{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.harpoon;
in
{
  options.modules.programs.nvim.plugins.harpoon = {
    enable = mkEnableOption "Enable programs.nvim.plugins.harpoon";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins.harpoon.enable = mkForce true;

      keymaps =
        with lib.nixvim;
        let
          inherit (config.lib.nixvim) mkRaw;
          harpoon = ''require("harpoon")'';
        in
        mkAfter [
          (mkKeymap "n" "<leader>a" (mkRaw ''function() ${harpoon}:list():add() end''))
          (mkKeymap "n" "<C-y>" (mkRaw ''function() ${harpoon}.ui:toggle_quick_menu(${harpoon}:list()) end''))
          (mkKeymap "n" "<C-h>" (mkRaw ''function() ${harpoon}:list():select(1) end''))
          (mkKeymap "n" "<C-j>" (mkRaw ''function() ${harpoon}:list():select(2) end''))
          (mkKeymap "n" "<C-k>" (mkRaw ''function() ${harpoon}:list():select(3) end''))
          (mkKeymap "n" "<C-l>" (mkRaw ''function() ${harpoon}:list():select(4) end''))
        ];
    };
  };
}
