lib:
with lib;
with lib.types;
(
  description: default:
  mkOption {
    type = int;
    inherit description default;
  }
)
