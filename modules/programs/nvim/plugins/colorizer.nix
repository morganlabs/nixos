{ config, lib, ... }:
with lib;
let
  cfg = config.modules.programs.nvim.plugins.colorizer;
in
{
  options.modules.programs.nvim.plugins.colorizer = {
    enable = mkEnableOption "Enable programs.nvim.plugins.colorizer";
  };

  config = mkIf cfg.enable {
    programs.nixvim.plugins.colorizer = {
      enable = mkForce true;
      settings.user_default_options = {
        RGB = mkForce true;
        RRGGBB = mkForce true;
        names = mkForce true;
        RRGGBBAA = mkForce true;
        rgb_fn = mkForce true;
        hsl_fn = mkForce true;
      };
    };
  };
}
