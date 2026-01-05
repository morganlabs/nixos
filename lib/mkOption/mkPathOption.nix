lib:
with lib;
with lib.types;
(
  description: default:
  mkOption {
    type = path;
    inherit description default;
  }
)
