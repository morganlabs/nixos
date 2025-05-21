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
  cfg = config.modules.programs.git;

  aliases = {
    gi = "git init";
    ga = "git add";
    gaa = "git add .";
    gc = "git commit";
    gca = "git commit -a";
    gp = "git push";
    gs = "git status";
  };
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.git = {
    enable = mkEnableOption "Enable programs.git";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ git ];
    home-manager.users.${vars.user.username} = {
      home.shellAliases = mkAfter aliases;
      programs.git = with vars; {
        enable = mkForce true;
        userName = mkForce user.fullName;
        userEmail = mkForce user.email.work;
        extraConfig = {
          init.defaultBranch = mkForce "main";
        };
      };
    };
  };
}
