{ config, lib, inputs, vars, ... }:
with lib;
let
  cfg = config.modules.programs.git;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.git = {
    enable = mkEnableOption "Enable programs.git";

    git-cliff.enable = mkEnableOption "Enable git-cliff for generating changelogs";
  };

  config = mkIf cfg.enable {
    modules.programs.git.git-cliff.enable = mkDefault true;

    programs.git = {
      enable = mkForce true;
      prompt.enable = mkForce true;
    };

    home-manager.users.${vars.user.username} = {
      programs.git = {
        enable = mkForce true;
        settings = with vars; {
          user.name = user.fullName;
          user.email = user.email.work;
          init.defaultBranch = "main";
        };
      };

      programs.git-cliff = mkIf cfg.git-cliff.enable {
        enable = mkForce true;
      };
    };
  };
}
