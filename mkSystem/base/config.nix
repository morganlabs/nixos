{ lib, vars, ... }:
with lib;
{
  users.users.${vars.user.username} = {
    isNormalUser = mkForce true;
    description = mkForce vars.user.fullName;
    extraGroups = mkBefore [ "wheel" ];
  };

  networking.hostName = mkForce vars.hostname;
  time.timeZone = mkForce vars.i18n.timeZone;
  services.xserver.xkb.layout = mkForce vars.i18n.xkbLayout;
  console.keyMap = mkForce vars.i18n.consoleKeymap;

  nix = {
    gc = {
      automatic = mkForce true;
      options = mkForce "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = mkForce true;
      experimental-features = mkForce [
        "nix-command"
        "flakes"
      ];
    };
  };

  i18n = {
    defaultLocale = mkForce vars.i18n.locale;
    extraLocaleSettings = {
      LC_ADDRESS = mkForce vars.i18n.locale;
      LC_IDENTIFICATION = mkForce vars.i18n.locale;
      LC_MEASUREMENT = mkForce vars.i18n.locale;
      LC_MONETARY = mkForce vars.i18n.locale;
      LC_NAME = mkForce vars.i18n.locale;
      LC_NUMERIC = mkForce vars.i18n.locale;
      LC_PAPER = mkForce vars.i18n.locale;
      LC_TELEPHONE = mkForce vars.i18n.locale;
      LC_TIME = mkForce vars.i18n.locale;
    };
  };
}
