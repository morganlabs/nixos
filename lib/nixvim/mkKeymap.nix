lib: mode: key: action:
let
  defaultOpts.silent = true;
in {
  inherit mode key action;
  options = lib.mkForce defaultOpts;
}
