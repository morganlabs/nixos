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
      map (
        m: with m; {
          name = id;
          value = pkgs.fetchurl {
            url = file;
            "${sha.type}" = sha.value;
          };
        }
      ) mods
    );

  # downloadModsToAttrs =
  #   mods:
  #   listToAttrs (
  #     map (m: {
  #       name = m.id;
  #       value =
  #         pkgs.fetchurl {
  #           url = m.file;
  #         }
  #         // (
  #           if m ? "sha512" then
  #             { sha512 = m.sha512; }
  #           else if m ? "sha256" then
  #             { sha256 = m.sha256; }
  #           else
  #             { sha256 = lib.fakeSha256; }
  #         );
  #     }) mods
  #   );

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
    services.minecraft-servers.servers.lps = {
      files = {
        "automodpack/host-modpack/main/mods" = clientMods;
        mods = serverMods;
      }
      // modConfigs;
    };
  };
}
