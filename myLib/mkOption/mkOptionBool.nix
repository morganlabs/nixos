{ lib }:
(
  description: default:
  lib.mkOption {
    type = lib.types.bool;
    inherit description default;
  }
)
