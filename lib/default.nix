lib: {
  mkTypeOption = import ./mkOption/mkTypeOption.nix lib;
  mkIntOption = import ./mkOption/mkIntOption.nix lib;
  mkBoolOption = import ./mkOption/mkBoolOption.nix lib;
  mkStringOption = import ./mkOption/mkStringOption.nix lib;

  mkIfElse = import ./mkIf/mkIfElse.nix;
  mkIfList = import ./mkIf/mkIfList.nix;
  mkIfStr = import ./mkIf/mkIfStr.nix;
  mkIfBool = import ./mkIf/mkIfBool.nix;

  nixvim = {
    mkKeymap = import ./nixvim/mkKeymap.nix lib;
  };
}
