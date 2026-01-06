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

  filterByRoles = roles: filter (m: elem m.role roles) mods;
  toLinkFarm = name: attrs: pkgs.linkFarmFromDrvs name (builtins.attrValues attrs);
  downloadModsToAttrs =
    mods:
    listToAttrs (
      map (m: {
        name = m.id;
        value = pkgs.fetchurl {
          url = m.file;
          sha512 = m.sha512;
        };
      }) mods
    );

  downloadAndFormat =
    linkFarmName: roles:
    let
      serverMods = filterByRoles roles;
      serverModsAttrs = downloadModsToAttrs serverMods;
    in
    toLinkFarm linkFarmName serverModsAttrs;

  serverMods = downloadAndFormat "server-only-mods" [
    "server"
    "both-optional"
    "both-required"
  ];
  clientMods = downloadAndFormat "client-required-mods" [
    "both-required"
    "client-required"
  ];

  ### CONFIGS ###
  modConfigs = listToAttrs (
    map (
      cfg:
      with cfg;
      let
        filename = baseNameOf path;
      in
      {
        name = path;
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
      files = {
        "automodpack/host-modpack/main/mods" = clientMods;
      }
      // modConfigs;
      symlinks = {
        mods = serverMods;
      };
    };
  };
}
