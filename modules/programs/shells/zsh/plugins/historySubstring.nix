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
  cfg = config.modules.programs.shells.zsh.plugins.historySubstring;

  pluginPkg = pkgs.zsh-history-substring-search;
  pluginPath = "/share/zsh-history-substring-search/zsh-history-substring-search.zsh";
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.shells.zsh.plugins.historySubstring = {
    enable = mkEnableOption "Enable programs.shells.zsh.plugins.historySubstring";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      home.packages = [ pluginPkg ];
      programs.zsh.initContent = mkAfter ''
        source "${pluginPkg}/${pluginPath}"
        bindkey "$terminfo[kcuu1]" history-substring-search-up
        bindkey "$terminfo[kcud1]" history-substring-search-down
      '';
    };
  };
}
