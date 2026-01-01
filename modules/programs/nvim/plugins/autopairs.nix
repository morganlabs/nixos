{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.autopairs;
in
{
  options.modules.programs.nvim.plugins.autopairs = {
    enable = mkEnableOption "Enable programs.nvim.plugins.autopairs";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.nvim-autopairs = {
      enable = mkForce true;
      settings.disable_filetype = (
        mkIfList config.modules.programs.nvim.plugins.telescope.enable [ "TelescopePrompt" ]
      );
    };
  };
}
