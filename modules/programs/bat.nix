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
  cfg = config.modules.programs.bat;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.bat = {
    enable = mkEnableOption "Enable programs.bat";
    replaceCat = mkBoolOption "Replace `cat`" true;
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      stylix.targets.bat.enable = mkForce true;
      home.shellAliases.cat = mkIfStr cfg.replaceCat "${pkgs.bat}/bin/bat";

      programs.bat = {
        enable = mkForce true;
        config.style = mkForce "full";
      };
    };
  };
}
