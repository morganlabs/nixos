{ inputs, ... }:
{
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.framework-11th-gen-intel
  ];

  boot.initrd.luks.devices."luks-14863952-c6ba-4d33-811e-f905506170ed".device =
    "/dev/disk/by-uuid/14863952-c6ba-4d33-811e-f905506170ed";

  modules = {
    desktop.hyprland.enable = true;

    security = {
      sudo-rs.enable = true;
      fprintd.enable = true;
    };

    boot = {
      systemd-boot.enable = true;
      plymouth.enable = true;
    };

    connectivity = {
      networkmanager.enable = true;
      bluetooth.enable = true;
      printing.enable = true;
    };

    hardware = {
      usb-automount.enable = true;

      power-management = {
        enable = true;
        intel.enable = true;
      };
    };

    decoration = {
      stylix.enable = true;
    };

    misc = {
      autologin.enable = true;
      aliases.enable = true;
      xdgUserDirs.enable = true;

      suspend-then-hibernate = {
        enable = true;
        resume-device = "/dev/mapper/luks-14863952-c6ba-4d33-811e-f905506170ed";
      };
    };

    programs = {
      shells.zsh.enable = true;
      nvim.enable = true;
      waybar.enable = true;
      bat.enable = true;
      btop.enable = true;
      eza.enable = true;
      kitty.enable = true;
      git.enable = true;
      fwupd.enable = true;
      steam.enable = true;
      cider2.enable = true;
      bitwarden.enable = true;
      waybar.modules.battery = {
        enable = true;
        bat = "BAT1";
        full_at = 90;
      };
    };
  };

  system.stateVersion = "24.11";
}
