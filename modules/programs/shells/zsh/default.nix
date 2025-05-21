{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.shells.zsh;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./plugins
  ];

  options.modules.programs.shells.zsh = {
    enable = mkEnableOption "Enable programs.shells.zsh";
    default = mkBoolOption "Make zsh the default shell" true;
  };

  config = mkIf cfg.enable {
    programs.zsh.enable = mkForce true;
    users.users.${vars.user.username}.shell = mkIf cfg.default pkgs.zsh;

    home-manager.users.${vars.user.username} = {
      config = mkIf cfg.enable {
        programs.zsh = {
          enable = mkForce true;
          autocd = mkForce true;
          enableCompletion = mkForce true;
          initContent = mkBefore ''PROMPT="%B%3~>%b "'';
        };
      };
    };

    modules.programs.shells.zsh.plugins = {
      autosuggestions.enable = mkDefault true;
      historySubstring.enable = mkDefault true;
      syntaxHighlighting.enable = mkDefault true;
    };
  };
}
