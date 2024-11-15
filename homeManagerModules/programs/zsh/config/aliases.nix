{ config, osConfig, lib, ... }:
with lib;
let
  aliases = mkMerge [
    {
      mkdir = "mkdir -p";
      c = "clear";
      l = "ls";
      e = "exit";
      src = "source $HOME/.zshrc";
    }
    (mkIf osConfig.programs.git.enable {
      gi = "git init";
      ga = "git add";
      gaa = "git add .";
      gc = "git commit";
      gca = "git commit --amend --no-edit";
      gcae = "git commit --amend";
      gcall = "git add . && git commit";
      gd = "git diff";
      gs = "git status";
      gp = "git push";
      gl = "git log --oneline";
      gll = "git log";
      gco = "git checkout";
      gfuck = "git reset --hard";
      gbr = "git branch --format=\"'%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:green) (%(committerdate:relative)) [ %(authorname) ]'\"";
    })
  ];
in
{
  programs.zsh.shellAliases = aliases;
}
