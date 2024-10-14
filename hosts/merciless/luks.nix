{ config, pkgs, ... }:
{
  boot.initrd.luks.devices."luks-8fcf19e4-f62d-4212-b294-f4bd3d3fd34c".device = "/dev/disk/by-uuid/8fcf19e4-f62d-4212-b294-f4bd3d3fd34c";
}
