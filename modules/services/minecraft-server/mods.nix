mods:
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.services.minecraft-server.mods;

  serverMods = filter (
    m:
    elem m.role [
      "server"
      "both-optional"
      "both-required"
    ]
  ) mods;

  ### ALL MODS ###
  serverModsAttrset = listToAttrs (
    map (m: {
      name = m.id;
      value = pkgs.fetchurl {
        url = m.file;
        sha512 = m.sha512;
      };
    }) serverMods
  );

  modsDerivation = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues serverModsAttrset);

  ### CONFIGS ###
  modConfigs = listToAttrs (
    map (
      cfg: with cfg; {
        name = "${directory}/${filename}";
        value = pkgs.writeText filename content;
      }
    ) (concatMap (mod: mod.config or [ ]) mods)
  );
in
{
  options.modules.services.minecraft-server.mods = {
    enable = mkEnableOption "Enable server.minecraft-server.mods";
  };

  config = mkIf cfg.enable {
    services.minecraft-servers.servers.fabric = {
      symlinks.mods = modsDerivation;
      files = modConfigs;
    };
  };
}
