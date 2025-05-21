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
  cfg = config.modules.programs.shells.zsh.plugins.syntaxHighlighting;

  pluginPkg = pkgs.zsh-syntax-highlighting;
  pluginPath = "/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.shells.zsh.plugins.syntaxHighlighting = {
    enable = mkEnableOption "Enable programs.shells.zsh.plugins.syntaxHighlighting";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      home.packages = [ pluginPkg ];
      programs.zsh.initContent = mkAfter ''source "${pluginPkg}/${pluginPath}" '';
    };
  };
}
