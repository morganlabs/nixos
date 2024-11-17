{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
let
  cfg = config.modules.shells.zsh;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.shells.zsh = {
    enable = mkEnableOption "Enable shells.zsh";
  };

  config = mkIf cfg.enable {
    users.users.${vars.user.username}.shell = pkgs.zsh;
    home-manager.users.${vars.user.username} = {
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
    };
  };
}
