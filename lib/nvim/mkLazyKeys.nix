{ lib, nixvim }:
with lib;
let
  mkLazyKeys =
    bindings:
    let
      formattedBindings = mapAttrs (bind: exec: ''{ "${bind}", ${exec} }, '') bindings;
    in
    nixvim.mkRaw "{ ${concatStringsSep "\n" (attrValues formattedBindings)} } ";
in
mkLazyKeys
