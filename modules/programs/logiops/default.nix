{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.logiops;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.logiops = {
    enable = mkEnableOption "Enable programs.logiops";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [ logiops ];
      etc."logid.cfg".text = import ./config.nix;
    };

    systemd.services.logid = {
      description = "Logitech Logid Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.logiops}/bin/logid";
        Restart = "always";
        RestartSec = 5;
        User = "root";
      };
    };
  };
}
