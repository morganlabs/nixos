{ lib }:
(
  description: default:
  lib.mkOption {
    type = lib.types.int;
    inherit description default;
  }
)
