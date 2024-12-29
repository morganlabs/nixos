{
  config,
  lib,
  inputs,
  vars,
  ...
}:
let
  cfg = config.modules.connectivity.networkmanager;
in
with lib;
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    (import ./controld.nix cfg)
  ];

  options.modules.connectivity.networkmanager = {
    enable = mkEnableOption "Enable connectivity.networkmanager";
    features.controld.enable = mkBoolOption "Use the ControlD DNS" true;

    wifi = {
      enable = mkBoolOption "Enable WiFi support" false;
      useIwd = mkBoolOption "Use IWD over wpa_supplicant for WiFi" true;
    };
  };

  config = mkIf cfg.enable {
    users.users.${vars.user.username}.extraGroups = mkDefault [ "networkmanager" ];
    networking.networkmanager = {
      enable = mkForce true;
      wifi.backend = mkForce (mkIfElse cfg.wifi.useIwd "iwd" "wpa_supplicant");
    };
  };
}
