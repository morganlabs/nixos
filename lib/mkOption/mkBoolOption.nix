lib:
with lib;
with lib.types;
(
  description: default:
  mkOption {
    type = bool;
    inherit description default;
  }
)
