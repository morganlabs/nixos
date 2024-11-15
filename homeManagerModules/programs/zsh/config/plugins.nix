{ pkgs, ... }:
let
  mkPlugin = pkg: path: { inherit pkg path; };

  plugins = with pkgs; [
    (mkPlugin zsh-autosuggestions "/share/zsh-autosuggestions/zsh-autosuggestions.zsh")
    (mkPlugin zsh-history-substring-search "/share/zsh-history-substring-search/zsh-history-substring-search.zsh")
    (mkPlugin zsh-syntax-highlighting "/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh")
  ];

  pluginPkgs = map (x: x.pkg) plugins;
  pluginStrs = map (x: "${x.pkg}/${x.path}") plugins;
in
{
  home.packages = pluginPkgs;
  programs.zsh.initExtraBeforeCompInit = builtins.concatStringsSep "\n" (
    map (item: "source \"${item}\"") pluginStrs
  );
}
