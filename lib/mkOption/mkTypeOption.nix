lib:
(
  type: description: default:
  lib.mkOption {
    type = lib.types.${type};
    inherit description default;
  }
)
