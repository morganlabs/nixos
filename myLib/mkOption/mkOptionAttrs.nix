{ lib }:
(
  description: default:
  lib.mkOption {
    type = lib.types.attrs;
    inherit description default;
  }
)
