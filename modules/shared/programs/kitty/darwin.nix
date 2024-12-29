{
  cfg,
  lib,
  vars,
}:
with lib;
{
  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.programs.kitty.font = {
      name = "MonaspiceKr Nerd Font Mono";
      size = 12;
    };
  };
}
