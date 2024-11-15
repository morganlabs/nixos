{ config, osConfig, pkgs, lib, vars, ... }:
let
  cfg = config.homeManagerModules.programs.git;
in
with lib;
{
  options.homeManagerModules.programs.git = {
    enable = mkEnableOption "Enable programs.git";
  };

  config = mkIf cfg.enable {
    programs.git = with vars; {
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

    programs.ssh = mkIf osConfig.programs._1password-gui.enable {
      enable = true;
      extraConfig = ''
        Host *
          IdentityAgent ~/.1password/agent.sock
      '';
    };
  };
}
