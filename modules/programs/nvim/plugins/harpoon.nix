{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.harpoon;

  harpoon = ''require("harpoon")'';
  mkHarpoonMap = key: content: (nixvim.mkKeymap "n" key ''<cmd>lua ${harpoon}${content}<CR>'');
in
{
  options.modules.programs.nvim.plugins.harpoon = {
    enable = mkEnableOption "Enable programs.nvim.plugins.harpoon";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {

      keymaps = [
        (mkHarpoonMap "<leader>a" '':list():add()'')
        (mkHarpoonMap "<C-y>" ''.ui:toggle_quick_menu(${harpoon}:list())'')
        (mkHarpoonMap "<C-h>" '':list():select(1)'')
        (mkHarpoonMap "<C-j>" '':list():select(2)'')
        (mkHarpoonMap "<C-k>" '':list():select(3)'')
        (mkHarpoonMap "<C-l>" '':list():select(4)'')
      ];

      plugins.harpoon = {
        enable = mkForce true;
        enableTelescope = mkForce config.modules.programs.nvim.plugins.telescope.enable;

        settings = {
          global_settings = {
            save_on_toggle = true;
          };
        };
      };
    };
  };
}
