{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.config.keymaps.replace-word;
in
{
  options.modules.programs.nvim.config.keymaps.replace-word = {
    enable = mkEnableOption "Enable programs.nvim.config.keymaps.replace-word";
  };

  config = mkIf cfg.enable {
    programs.nixvim.keymaps = with lib.nixvim; [
      (mkKeymap "n" "<leader>e" ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
    ];
  };
}
