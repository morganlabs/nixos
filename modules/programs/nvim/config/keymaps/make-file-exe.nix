{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.config.keymaps.make-file-exe;
in
{
  options.modules.programs.nvim.config.keymaps.make-file-exe = {
    enable = mkEnableOption "Enable programs.nvim.config.keymaps.make-file-exe";
  };

  config = mkIf cfg.enable {
    programs.nixvim.keymaps = with lib.nixvim; [
      (mkKeymap "n" "<leader>x" ":!chmod +x %<CR>")
    ];
  };
}
