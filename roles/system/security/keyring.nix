{
  config,
  lib,
  myLib,
  pkgs,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.security.keyring;
in
{
  options.roles.security.keyring = {
    enable = mkEnableOption "Enable GNOME Keyring";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ libsecret ];
    services.gnome.gnome-keyring.enable = true;
  };
}
