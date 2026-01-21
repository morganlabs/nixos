{ lib, pkgs, ... }:
with lib;
{
  imports = [
    ./hardware.nix
    ./networking.nix
  ];

  modules = {
    core.enable = true;

    bootloader = {
      systemd-boot.enable = false;
      grub = {
        enable = true;
        devices = [
          "/dev/sda"
          "/dev/sdb"
        ];
      };
    };

    hardware.bluetooth.enable = false;

    programs = {
      node.enable = true;
      stylix.enable = false;
    };

    services = {
      traefik.enable = true;
      flame.enable = true;
      status.enable = true;
      sabnzbd.enable = true;
      lidarr.enable = true;
      vaultwarden.enable = true;
      nextcloud.enable = true;

      navidrome = {
        enable = true;
        useMinIO = true;
      };

      minecraft-server = {
        enable = true;
        website.enable = true;
        rcon.enable = true;

        whitelist = {
          Durabilitas = "1459c26c-6296-49a9-adbf-2eec51b661b7";
          ijusthatemyself = "8dd83707-3ffe-4030-834c-b2e1681bfc72";
          Demissus = "4e79548e-90b4-4830-acfa-ab8f9d56fd60";
          S3THY122 = "ec72d038-3a61-44d6-9527-874ccc4ad13b";
        };
      };
    };
  };

  hardware.graphics = {
    enable = true;

    extraPackages = with pkgs; [
      intel-ocl
      intel-vaapi-driver
      libva-vdpau-driver
      intel-compute-runtime-legacy1
    ];
  };

  boot = {
    swraid.enable = true;
    kernelParams = [ "boot.shell_on_fail" ];
    swraid.mdadmConf = ''HOMEHOST <ignore>'';
  };

  systemd.services.mdmonitor = {
    wantedBy = mkForce [ ];
    requires = mkForce [ ];
  };

  system.stateVersion = "25.05";
}
