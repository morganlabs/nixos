{
  lib,
  inputs,
  pkgs,
}:
let
  nixvim = inputs.nixvim.lib.${pkgs.system}.helpers;
in
{
  mkIfElse = import ./mkIf/mkIfElse.nix;
  mkIfList = import ./mkIf/mkIfList.nix;
  mkIfStr = import ./mkIf/mkIfStr.nix;

  mkAttrsOption = import ./mkOption/mkAttrsOption.nix { inherit lib; };
  mkBoolOption = import ./mkOption/mkBoolOption.nix { inherit lib; };
  mkListOfOption = import ./mkOption/mkListOfOption.nix { inherit lib; };
  mkIntOption = import ./mkOption/mkIntOption.nix { inherit lib; };
  mkStrOption = import ./mkOption/mkStrOption.nix { inherit lib; };
  mkPkgOption = import ./mkOption/mkPkgOption.nix { inherit lib; };

  importWith = import ./importWith.nix { };

  nvim = with inputs; {
    mkLazyKeys = import ./nvim/mkLazyKeys.nix { inherit lib nixvim; };
  };
}
