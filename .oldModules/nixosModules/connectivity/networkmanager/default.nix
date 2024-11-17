{
  config,
  lib,
  vars,
  ...
}:
let
  cfg = config.nixosModules.connectivity.networkmanager;
in
with lib;
{
  options.nixosModules.connectivity.networkmanager = {
    enable = mkEnableOption "Enable connectivity.networkmanager";
    features.controld.enable = mkBoolOption "Use the ControlD DNS" true;

    wifi = {
      enable = mkBoolOption "Enable WiFi support" false;
      useIwd = mkBoolOption "Use IWD over wpa_supplicant for WiFi" true;
    };
  };

  imports = [
    (import ./controld.nix cfg)
  ];

  config = mkIf cfg.enable {
    users.users.${vars.user.username}.extraGroups = mkDefault [ "networkmanager" ];
    networking.networkmanager = {
      enable = mkForce true;
      wifi.backend = mkForce (mkIfElse cfg.wifi.useIwd "iwd" "wpa_supplicant");
    };
  };
}
