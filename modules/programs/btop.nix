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
  cfg = config.modules.programs.btop;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.btop = {
    enable = mkEnableOption "Enable programs.btop";
    replaceTop = mkBoolOption "Replace `top`" true;
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      stylix.targets.btop.enable = mkForce true;
      home.shellAliases.top = mkIfStr cfg.replaceTop "${pkgs.btop}/bin/btop";
      programs.btop.enable = mkForce true;
    };
  };
}
