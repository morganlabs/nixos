{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./luks.nix
    ../../roles/system
  ];

  roles = {
    laptop.powerManagement = {
      enable = true;
      features.powerProfiles.enable = true;
    };
  };
  system.stateVersion = "24.05";
}
