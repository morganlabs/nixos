{ lib }:
(
  listOfType: description: default:
  lib.mkOption {
    type = lib.types.listOf listOfType;
    inherit description default;
  }
)
