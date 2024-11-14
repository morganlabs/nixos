hostname: { lib, ... }:
with lib;
{
  programs.git.enable = mkForce true;
  networking.hostName = mkForce hostname;
  nix.settings.experimental-features = mkDefault [
    "nix-command"
    "flakes"
  ];
}
