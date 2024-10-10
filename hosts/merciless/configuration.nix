{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./luks.nix
    ../../roles/system
  ];

  system.stateVersion = "24.05";
}
