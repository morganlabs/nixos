{ ... }:
{
  imports = [ ./hardware-configuration.nix ];

  modules = {
    base.user.features.autologin.enable = true;
    security.gnome-keyring.enable = true;
    decoration.stylix.enable = true;

    bundles = {
      shell.enable = true;
      connectivity.enable = true;
      hyprland.enable = true;
      desktop.enable = true;
      sound.enable = true;
      gamedev.enable = true;
    };

    programs.waybar.modules = {
      backlight.enable = true;
      battery = {
        enable = true;
        bat = "BAT0";
      };
    };

    functions = {
      screenshot.enable = true;
      backlight.enable = true;
      volume.enable = true;
      music.enable = true;
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "24.05";
}
