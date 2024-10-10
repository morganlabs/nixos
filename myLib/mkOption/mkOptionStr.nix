{ lib }:
(
  description: default:
  lib.mkOption {
    type = lib.types.str;
    inherit description default;
  }
)
