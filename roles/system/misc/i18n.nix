{
  config,
  lib,
  myLib,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.misc.i18n;
in
{
  options.roles.misc.i18n = {
    enable = mkEnableOption "The default i18n settings for my systems";
  };

  config = mkIf cfg.enable {
    time.timeZone = "Europe/London";
    console.keyMap = "uk";
    i18n = {
      defaultLocale = "en_GB.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "en_GB.UTF-8";
        LC_IDENTIFICATION = "en_GB.UTF-8";
        LC_MEASUREMENT = "en_GB.UTF-8";
        LC_MONETARY = "en_GB.UTF-8";
        LC_NAME = "en_GB.UTF-8";
        LC_NUMERIC = "en_GB.UTF-8";
        LC_PAPER = "en_GB.UTF-8";
        LC_TELEPHONE = "en_GB.UTF-8";
        LC_TIME = "en_GB.UTF-8";
      };
    };

    services.xserver.xkb = {
      layout = "gb";
      variant = "";
    };
  };
}
