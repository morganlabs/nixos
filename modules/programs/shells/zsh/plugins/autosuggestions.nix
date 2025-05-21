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
  cfg = config.modules.programs.shells.zsh.plugins.autosuggestions;

  pluginPkg = pkgs.zsh-autosuggestions;
  pluginPath = "/share/zsh-autosuggestions/zsh-autosuggestions.zsh";
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.shells.zsh.plugins.autosuggestions = {
    enable = mkEnableOption "Enable programs.shells.zsh.plugins.autosuggestions";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      home.packages = [ pluginPkg ];
      programs.zsh.initContent = mkAfter ''source "${pluginPkg}/${pluginPath}"'';
    };
  };
}
