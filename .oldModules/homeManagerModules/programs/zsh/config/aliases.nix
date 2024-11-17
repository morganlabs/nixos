{ osConfig, lib, ... }:
with lib;
let
  aliases = {
    mkdir = "mkdir -p";
    c = "clear";
    e = "exit";
    src = "source $HOME/.zshrc";
  };
in
{
  programs.zsh.shellAliases = aliases;
}
