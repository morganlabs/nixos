{ ... }:
{
  imports = [ ./hardware.nix ];

  modules = {
    security.sudo-rs.enable = true;
    boot.systemd-boot.enable = true;
    hardware.power-management.enable = true;

    connectivity = {
      networkmanager.enable = true;
      bluetooth.enable = true;
    };

    misc = {
      autologin.enable = true;
      aliases.enable = true;
    };

    programs = {
      nvim.enable = true;
      git.enable = true;
      steam = {
        enable = true;
        standalone.enable = true;
      };
    };
  };

  system.stateVersion = "24.11";
}
