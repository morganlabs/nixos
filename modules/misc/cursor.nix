{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.misc.cursor;
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.misc.cursor = {
    enable = mkEnableOption "Enable misc.cursor";
    name = mkStringOption "The name of the cursor to use (Must come from the package provided!)" "Bibata-Modern-Classic";
    package = mkTypeOption "package" "The cursor package to use" pkgs.bibata-cursors;
    size = mkIntOption "The size of the cursor" 24;
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.home.pointerCursor = {
      inherit (cfg) name package size;

      # gtk = {
      #   enable = mkForce true;
      #   cursorTheme = { inherit (cfg) name size; };
      # };

      x11 = {
        enable = mkForce true;
        defaultCursor = mkForce cfg.name;
      };
    };
  };
}
