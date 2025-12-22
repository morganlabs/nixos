{ config, pkgs, vars, ... }:

{
  imports = [ ./hardware.nix ];

  modules = {
    programs = {
      git.enable = true;
    };
  };

  nix.settings.trusted-users = [ vars.user.username ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = vars.hostname;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
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

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${vars.user.username} = {
    isNormalUser = true;
    description = vars.user.fullName;
    extraGroups = [ "wheel" ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  programs.git.enable = true;

  networking.firewall.enable = true;

  system.stateVersion = "25.11";
}
