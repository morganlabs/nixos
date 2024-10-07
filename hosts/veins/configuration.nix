{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./luks.nix
    ../../roles/system
  ];

  roles = {
    defaultUser.enable = true;

    bootloader.grub.enable = true;
    sound.pipewire.enable = true;

    misc = {
      i18n.enable = true;
      security.enable = true;
      defaultFonts.enable = true;
    };

    connectivity = {
      ssh.enable = true;
      networkmanager.enable = true;
      firewall.enable = true;
      bluetooth.enable = true;
    };

    laptop.powerManagement = {
      enable = true;
      features.powerProfiles.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    neovim
  ];

  hardware.graphics.enable = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  system.stateVersion = "24.05";
}
