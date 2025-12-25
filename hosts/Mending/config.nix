{ ... }:

{
  imports = [ ./hardware.nix ];

  modules = {
    core.enable = true;
  };

  system.stateVersion = "25.11";
}
