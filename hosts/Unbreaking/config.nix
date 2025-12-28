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

    programs.node.enable = true;

    services = {
      traefik.enable = true;
      flame.enable = true;
      status.enable = true;
      sabnzbd.enable = true;
      sonarr.enable = true;

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
        };
      };

      jellyfin = {
        enable = true;
        useMinIO = true;
        hardwareAcceleration.enable = true;

        decodingCodecs = {
          mpeg2 = true;
          hevc = true;
          h264 = true;
        };

        transcoding = {
          maxConcurrentStreams = 4;
          enableHardwareEncoding = true;
          deleteSegments = true;
          encodingPreset = "medium";
        };
      };
    };
  };

  ### JELLYFIN HARDWARE ACCELERATION ###
  systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "i965"; # or i965 for older GPUs
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "i965";
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
