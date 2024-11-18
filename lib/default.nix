{ lib, ... }:
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

  firefox = {
    mkBookmark = import ./firefox/mkBookmark.nix;
  };
}
