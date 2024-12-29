{ hostname, luksDevice }:
{ lib, ... }:
with lib;
{
  modules = {
    decoration.stylix.enable = true;
    shells.zsh.enable = true;

    base = {
      i18n.enable = true;
      user.enable = true;
      xdgUserDirs.enable = true;
    };
  };

  boot.initrd.luks.devices = mkIf (luksDevice != "") {
    "luks-${luksDevice}".device = mkForce "/dev/disk/by-uuid/${luksDevice}";
  };

  # Basic Settings
  programs.git.enable = mkForce true;
  networking.hostName = mkForce hostname;

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = mkDefault [
        "nix-command"
        "flakes"
      ];
    };
  };
}
