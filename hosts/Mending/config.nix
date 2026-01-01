{ inputs, ... }: {
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  modules = {
    core.enable = true;
  };

  system.stateVersion = "25.11";
}
