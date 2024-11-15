{ hostname, luksDevice }: { lib, ... }:
with lib;
{
  boot.initrd.luks.devices = mkIf (luksDevice != "") {
    "luks-${luksDevice}".device = mkForce "/dev/disk/by-uuid/${luksDevice}";
  };

  programs.git.enable = mkForce true;
  networking.hostName = mkForce hostname;
  nix.settings.experimental-features = mkDefault [
    "nix-command"
    "flakes"
  ];
}
