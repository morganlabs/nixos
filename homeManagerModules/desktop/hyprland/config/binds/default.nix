cfg: { config, lib, ... }:
with lib;
{
  imports = [
    (import ./windowActions.nix cfg)
    (import ./workspaceActions.nix cfg)
  ];
}
