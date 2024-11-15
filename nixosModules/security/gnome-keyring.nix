{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.nixosModules.security.gnome-keyring;
in
with lib;
{
  options.nixosModules.security.gnome-keyring = {
    enable = mkEnableOption "Enable security.gnome-keyring";
    features.unlockOnLogin = mkBoolOption "Unlock GNOME Keyring on Login" true;
  };

  config = mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = cfg.features.unlockOnLogin;
  };
}
