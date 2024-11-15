{ lib }:
(
  description: default:
  lib.mkOption {
    type = lib.types.package;
    inherit description default;
  }
)
