lib:
with lib;
with lib.types;
(
  description: default:
  mkOption {
    type = str;
    inherit description default;
  }
)
