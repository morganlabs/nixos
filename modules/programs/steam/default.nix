{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.steam;
in
with lib;
{
  options.modules.programs.steam = {
    enable = mkEnableOption "Enable programs.steam";
    standalone.enable = mkBoolOption "Make Steam a standalone DE - Simulate a Steam Deck" false;
  };

  config = mkIf cfg.enable {
    programs = {
      steam = {
        enable = mkForce true;
        localNetworkGameTransfers.openFirewall = mkDefault true;
        gamescopeSession.enable = mkDefault cfg.standalone.enable;
      };

      gamescope = mkIf cfg.standalone.enable {
        enable = mkForce true;
        capSysNice = mkForce true;
      };
    };

    environment = {
      systemPackages = with pkgs; [ mangohud ];
      loginShellInit = mkIfStr cfg.standalone.enable ''
        [[ "$(tty)" = "/dev/tty1" ]] && ${./gamescope.sh}
      '';
    };
  };
}
