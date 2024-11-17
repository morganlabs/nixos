{ config, lib, ... }:
with lib;
{
  imports = [
    ./windowActions.nix
    ./workspaceActions.nix
    ./exec.nix
  ];
}
