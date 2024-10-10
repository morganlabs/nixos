{
  config,
  lib,
  myLib,
  pkgs,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.programs.discord;
in
{
  options.roles.programs.discord = {
    enable = mkEnableOption "Enable Discord";

    features.discover.enable = mkOptionBool "Enable Discover overlay" true;
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      mkMerge [
        [ discord ]
        (mkIfList cfg.features.discover.enable [ discover-overlay ])
      ];

    # Need to do this as Discover needs write access to the config file.
    home.activation.setupDiscoverConfig =
      let
        defaultConfig = builtins.readFile ./discover_config.ini;
      in
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        CONFIG_FILE="$HOME/.config/discover_overlay/config.ini"
        mkdir -p "$(dirname "$CONFIG_FILE")"
        echo "${defaultConfig}" > "$CONFIG_FILE"
      '';
  };
}
