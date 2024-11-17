{ hostname, luksDevice }:
{
  lib,
  vars,
  pkgs,
  config,
  ...
}:
with lib;
{
  boot.initrd.luks.devices = mkIf (luksDevice != "") {
    "luks-${luksDevice}".device = mkForce "/dev/disk/by-uuid/${luksDevice}";
  };

  # Basic Settings
  programs.git.enable = mkForce true;
  networking.hostName = mkForce hostname;

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = mkDefault [
        "nix-command"
        "flakes"
      ];
    };
  };

  # User Config
  systemd.services."getty@tty1" = mkIfStr (luksDevice != "") (mkDefault ({
    overrideStrategy = "asDropin";
    serviceConfig.ExecStart = [
      ""
      "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} --autologin ${vars.user.username} --noclear --keep-baud %I 115200,38400,9600 $TERM"
    ];
  }));

  programs.zsh.enable = mkDefault true;
  users.users.${vars.user.username} = {
    isNormalUser = mkForce true;
    description = mkForce vars.user.name;
    extraGroups = mkDefault [ "wheel" ];
  };

  # i18n
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
}
