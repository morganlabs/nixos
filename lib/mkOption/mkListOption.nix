lib:
with lib;
with lib.types;
(
  type: description: default:
  mkOption {
    type = listOf lib.types.${type};
    inherit description default;
  }
)
