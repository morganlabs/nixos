{ lib }:
{
  mkIfElse = import ./mkIf/mkIfElse.nix;
  mkIfList = import ./mkIf/mkIfList.nix;
  mkIfStr = import ./mkIf/mkIfStr.nix;

  mkOptionAttrs = import ./mkOption/mkOptionAttrs.nix { inherit lib; };
  mkOptionBool = import ./mkOption/mkOptionBool.nix { inherit lib; };
  mkOptionListOf = import ./mkOption/mkOptionListOf.nix { inherit lib; };
  mkOptionInt = import ./mkOption/mkOptionInt.nix { inherit lib; };
  mkOptionStr = import ./mkOption/mkOptionStr.nix { inherit lib; };
}
