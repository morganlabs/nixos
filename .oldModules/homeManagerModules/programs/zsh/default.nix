{ config, lib, ... }:
let
  cfg = config.homeManagerModules.programs.zsh;
in
with lib;
{
  options.homeManagerModules.programs.zsh = {
    enable = mkEnableOption "Enable programs.zsh";
  };

  imports = [
    ./config/plugins.nix
    ./config/functions.nix
    ./config/aliases.nix
    ./config/sessionVariables.nix
  ];

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      autocd = true;
      enableCompletion = true;
      initExtra = ''
        PROMPT="%3~> "
      '';
    };
  };
}
