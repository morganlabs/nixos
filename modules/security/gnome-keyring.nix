{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.modules.security.gnome-keyring;
in
with lib;
{
  options.modules.security.gnome-keyring = {
    enable = mkEnableOption "Enable security.gnome-keyring";
    features = {
      unlockOnLogin = mkBoolOption "Unlock GNOME Keyring on Login" true;
      autostart = mkBoolOption "Automatically run the Keyring Daemon" true;
      withSeahorse = mkBoolOption "Install Seahorse" true;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ seahorse ];
    services.gnome.gnome-keyring.enable = true;
    security.pam.services.login.enableGnomeKeyring = cfg.features.unlockOnLogin;

    systemd.user.services.gnome-keyring = mkIf cfg.features.autostart {
      enable = true;
      description = "GNOME Keyring Daemon";
      wantedBy = [ "default.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon --start --components=secrets";
        RuntimeDirectory = "keyring";
        RuntimeDirectoryMode = "0700";
        LimitMEMLOCK = "16380";
        Environment = [
          "XDG_RUNTIME_DIR=/run/user/%U"
          "SSH_AUTH_SOCK=/run/user/%U/keyring/ssh"
        ];
      };
    };
  };
}
