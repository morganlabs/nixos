lib:
with lib;
with lib.types;
(
  description: default:
  mkOption {
    type = package;
    inherit description default;
  }
)
