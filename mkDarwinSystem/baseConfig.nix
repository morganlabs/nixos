{ system }: 
{ lib, ... }:
with lib;
{
  modules = {
    base.user.enable = mkForce true;
  };

  # Basic Settings
  nix = {
    optimise.automatic = true;
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = mkDefault [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs.hostPlatform = system;
}
