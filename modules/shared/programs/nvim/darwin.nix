{ cfg, lib }:
with lib;
{
  config = mkIf cfg.enable {
    environment.variables.EDITOR = "nvim";
  };
}
