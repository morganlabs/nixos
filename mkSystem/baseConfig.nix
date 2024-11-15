{ hostname, luksDevice }:
{
  lib,
  vars,
  pkgs,
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
  nix.settings.experimental-features = mkDefault [
    "nix-command"
    "flakes"
  ];

  # User Config
  services.getty.autologinUser = mkIfStr (luksDevice != "") mkDefault "morgan"; # TODO: Make this only happen on first tty
  programs.zsh.enable = mkDefault true;
  users.users.${vars.user.username} = {
    isNormalUser = mkForce true;
    description = mkForce vars.user.name;
    extraGroups = mkDefault [
      "wheel"
      "networkmanager"
    ];
    shell = mkForce pkgs.zsh;
  };

  # i18n
  time.timeZone = "Europe/London";
  console.keyMap = "uk";

  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

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
