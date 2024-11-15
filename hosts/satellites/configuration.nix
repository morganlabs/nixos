{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  nixosModules = {
    desktop.hyprland.enable = true;
    decoration.stylix.enable = true;

    programs = {
      _1password.enable = true;
      spotify.enable = true;
    };

    connectivity = {
      networkmanager.enable = true;
      bluetooth.enable = true;
      firewall.enable = true;
      ssh.enable = true;
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
