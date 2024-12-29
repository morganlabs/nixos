{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.modules.base.i18n;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.base.i18n = {
    enable = mkEnableOption "Enable base.i18n";
    features.autologin.enable = mkBoolOption "Automatically log in to TTY1" false;
  };

  config = mkIf cfg.enable {
    services.xserver.xkb.layout = "gb";
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
  };
}
