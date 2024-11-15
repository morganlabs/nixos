{ hostname, luksDevice }: { lib, vars, pkgs, ... }:
with lib;
{
  boot.initrd.luks.devices = mkIf (luksDevice != "") {
    "luks-${luksDevice}".device = mkForce "/dev/disk/by-uuid/${luksDevice}";
  };

  # Basic Settings
  programs.git.enable = mkForce true;
  networking.hostName = mkForce hostname;
  nix.settings.experimental-features = mkDefault [ "nix-command" "flakes" ];

  # User Config
  services.getty.autologinUser = mkIfStr (luksDevice != "") mkDefault "morgan"; # TODO: Make this only happen on first tty
  programs.zsh.enable = mkDefault true;
  users.users.${vars.user.username} = {
    isNormalUser = mkForce true;
    description = mkForce vars.user.name;
    extraGroups = mkDefault [ "wheel" "networkmanager" ];
    shell = mkForce pkgs.zsh;
  };
}
