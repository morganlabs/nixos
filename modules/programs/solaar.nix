{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.solaar;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.solaar = {
    enable = mkEnableOption "Enable programs.solaar";
    features.systemd = {
      enable = mkBoolOption "Create a SystemD Service for Solaar" true;
      autostart.enable = mkBoolOption "Automatically start the SystemD Service" true;
    };
  };

  config = mkIf cfg.enable {
    hardware.logitech.wireless.enable = true;
    environment.systemPackages = with pkgs; [ solaar ];
  };
}
