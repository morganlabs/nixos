{ ... }:
{
  imports = [
    ../../roles/home
  ];

  roles = {
    desktop.waybar.modules = {
      brightness.enable = true;
      volume.enable = true;
      battery.enable = true;
      bluetooth.enable = true;
      network.enable = true;
      tray.enable = true;
    };
  };

  home.stateVersion = "24.05";
}
