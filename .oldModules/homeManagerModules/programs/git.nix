{
  config,
  osConfig,
  pkgs,
  lib,
  vars,
  ...
}:
let
  cfg = config.homeManagerModules.programs.git;
  aliases = {
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
    gbr = ''git branch --format="'%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:green) (%(committerdate:relative)) [ %(authorname) ]'"'';
  };
in
with lib;
{
  options.homeManagerModules.programs.git = {
    enable = mkEnableOption "Enable programs.git";
    features.aliases.enable = mkBoolOption "Enable Aliases for all shells" true;
  };
  config = mkIf cfg.enable {
    programs = mkMerge [
      {
        git = with vars; {
          enable = mkForce true;
          userName = mkForce user.name;
          userEmail = mkForce user.email.work;
          extraConfig = mkMerge [
            { init.defaultBranch = mkForce "main"; }
            (mkIf osConfig.programs._1password-gui.enable {
              user.signingkey = vars.git.ssh.pubkey;
              commit.gpgsign = true;
              gpg = {
                format = "ssh";
                ssh.program = "${lib.getExe' pkgs._1password-gui "op-ssh-sign"}";
              };
            })
          ];
        };
        ssh = mkIf osConfig.programs._1password-gui.enable {
          enable = true;
          extraConfig = ''
            Host *
              IdentityAgent ~/.1password/agent.sock
          '';
        };
      }
      (mkIf cfg.features.aliases.enable {
        bash.shellAliases = mkIf osConfig.programs.bash.enable aliases;
        zsh.shellAliases = mkIf osConfig.programs.zsh.enable aliases;
      })
    ];
  };
}
