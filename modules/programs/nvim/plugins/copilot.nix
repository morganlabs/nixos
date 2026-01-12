{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.copilot;
in
{
  options.modules.programs.nvim.plugins.copilot = {
    enable = mkEnableOption "Enable programs.nvim.plugins.copilot";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins = {
      copilot-vim = {
        enable = mkForce true;
        autoLoad = mkDefault true;
        package = pkgs.vimPlugins.copilot-vim;
      };

      copilot-chat = {
        enable = mkForce true;
        autoLoad = mkDefault true;
        package = pkgs.vimPlugins.CopilotChat-nvim;
      };
    };
  };
}
