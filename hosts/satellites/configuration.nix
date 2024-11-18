{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  modules = {
    base.user.features.autologin.enable = true;
    graphics.amdgpu.enable = true;
    security.gnome-keyring.enable = true;
    decoration.stylix.enable = true;

    bundles = {
      shell.enable = true;
      connectivity.enable = true;
      hyprland.enable = true;
      desktop.enable = true;
      gaming.enable = true;
      sound.enable = true;
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.05";
}
