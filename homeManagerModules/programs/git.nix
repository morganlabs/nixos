{ config, lib, vars, ... }:
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
      extraConfig = { init.defaultBranch = mkForce "main"; };
    };
  };
}
