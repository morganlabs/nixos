{ ... }:
{
  imports = [ ../../roles/home ];

  roles = {
    games = {
      minecraft.enable = true;
    };

    desktop.waybar.modules = {
      volume.enable = true;
      network.enable = true;
      bluetooth.enable = true;
      tray.enable = true;
    };
  };

  home.stateVersion = "24.05";
}
