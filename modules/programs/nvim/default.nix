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
  imports = [
    inputs.nixvim.nixosModules.nixvim
    ./config
  ];

  options.modules.programs.nvim = {
    enable = mkEnableOption "Enable programs.nvim";
    defaultEditor = mkBoolOption "Make Neovim the EDITOR" true;
    alias = mkBoolOption "Alias `nvim` to `vi` and `vim`" true;
  };

  config = mkIf cfg.enable {
    modules.programs.nvim = {
      config = {
        line-numbers = {
	  nu = mkDefault true;
	  rnu = mkDefault true;
	};
      };
    };

    environment.sessionVariables = mkIf cfg.defaultEditor {
      EDITOR = mkForce "nvim";
    };

    programs.nixvim = {
      enable = mkForce true;
      viAlias = mkForce cfg.alias;
      vimAlias = mkForce cfg.alias;
    };
  };
}
