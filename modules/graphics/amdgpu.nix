{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.modules.graphics.amdgpu;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.graphics.amdgpu = {
    enable = mkEnableOption "Enable graphics.amdgpu";
  };

  config = mkIf cfg.enable {
    boot.initrd.kernelModules = mkDefault [ "amdgpu" ];
    services.xserver.videoDrivers = mkDefault [ "amdgpu" ];

    hardware = {
      graphics = {
        enable32Bit = mkDefault true;
        extraPackages = with pkgs; mkDefault [ rocmPackages.clr.icd ];
      };

      amdgpu = {
        opencl.enable = mkDefault true;
        amdvlk = {
          enable = mkDefault true;
          support32Bit.enable = mkDefault true;
        };
      };
    };

    systemd.tmpfiles.rules = mkDefault [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
  };
}
