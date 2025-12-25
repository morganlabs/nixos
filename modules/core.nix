{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.core;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.core = {
    enable = mkEnableOption "Enable core";
  };

  config = mkIf cfg.enable {
    modules = {
      bootloader.systemd-boot.enable = mkDefault true;

      programs.git.enable = mkDefault true;

      networking.enable = mkDefault true;
      hardware.bluetooth.enable = mkDefault true;
      services.ssh.enable = mkDefault true;
    };

    nix.settings.trusted-users = [ vars.user.username ];
    networking.hostName = vars.hostname;

    console.keyMap = "uk";
    time.timeZone = "Europe/London";
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

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${vars.user.username} = {
      isNormalUser = true;
      description = vars.user.fullName;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keys = [ vars.sshKey ];
    };

    home-manager.users.${vars.user.username} = { };
  };
}
