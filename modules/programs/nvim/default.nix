{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.nvim;
in
{
  imports = [ inputs.nixvim.nixosModules.nixvim ];

  options.modules.programs.nvim = {
    enable = mkEnableOption "Enable programs.nvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = mkForce true;
      plugins.lualine.enable = mkForce true;
    };
  };
}
