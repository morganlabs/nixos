{
  config,
  lib,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.programs.mangohud;
in
{
  options.modules.programs.mangohud = {
    enable = mkEnableOption "Enable programs.mangohud";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      stylix.targets.mangohud.enable = true;

      programs.mangohud = {
        enable = mkForce true;
        settings = {
          position = "top-left";
          horizontal = true;
          cpu_temp = true;
          gpu_temp = true;
          ram = true;
          vram = true;
          fps = true;
          toggle_hud = "F12";
        };
      };
    };
  };
}
