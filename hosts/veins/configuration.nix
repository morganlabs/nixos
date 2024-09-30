{ config, pkgs, user, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./luks.nix
    ../../roles/system
  ];


  roles = {
    grub.enable = true;
    i18n.enable = true;

    ssh.enable = true;
    networkmanager.enable = true;
    firewall.enable = true;
    security.enable = true;
    defaultUser.enable = true;
    defaultFonts.enable = true;

    pipewire.enable = true;
  };

  environment.systemPackages = with pkgs; [
    neovim
  ];
  

  hardware.graphics.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  system.stateVersion = "24.05";
}
