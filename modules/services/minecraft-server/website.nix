catalogue:
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.services.minecraft-server.website;

  port = 4587;

  filterModsByRolesAndTags =
    roles: tags:
    let
      modMatchesRole = m: any (r: r == m.role) roles;
      modMatchesTag = m: any (t: elem t m.tags) tags;
    in
    filter (m: modMatchesRole m || modMatchesTag m) catalogue.mods;

  optionalModsList = filterModsByRolesAndTags [ "client-optional" "both-optional" ] [ "Support Mod" ];

  mkSymlinkScript =
    modsList:
    concatMapStringsSep "\n" (
      m:
      let
        fname = "${lib.replaceStrings [ " " ] [ "_" ] m.title}.jar";
        drv = pkgs.fetchurl {
          url = m.file;
          "${m.sha.type}" = m.sha.value;
        };
      in
      "ln -sf ${drv} \"${fname}\"" # ← "${fname}" only (relative to mods/)
    ) modsList;

  mkModZip =
    zipName: modsList:
    pkgs.runCommand "${zipName}.zip" { } ''
      set -eu
      mkdir -p "mods"

      cd "mods"
      ${mkSymlinkScript modsList}
      cd ..

      ${pkgs.zip}/bin/zip -r "$out" mods/
    '';

  optionalModsZip = mkModZip "lpsmp-optional-mods" optionalModsList;

  minecraftWebsite = pkgs.buildNpmPackage {
    pname = "minecraft-mod-website";
    version = "1.0.0";
    src = ./web;
    npmDepsHash = "sha256-2Jr8EPZomibQEKVYm/doIfZJS4RSa+8b/5kUHblqpwQ=";
    npmFlags = [ "--legacy-peer-deps" ];
    buildInputs = with pkgs; [ nodejs ];

    buildPhase = ''
      mkdir -p src/data
      cp ${./catalogue/catalogue.lock.json} src/data/catalogue.json
      npm run build
    '';

    installPhase = "cp -r dist $out";
  };

  mkZipAlias = zipFile: {
    alias = toString zipFile;
    extraConfig = ''
      autoindex off;
      add_header Content-Type application/zip;
    '';
  };
in
{
  options.modules.services.minecraft-server.website = {
    enable = mkEnableOption "Enable services.minecraft-server.website";
    addToDash = mkEnableOption "Add the website to the dashboard";
    traefik.enable = mkEnableOption "Enable Traefik routing";
  };

  config = mkIf cfg.enable {
    modules.services.minecraft-server.website = {
      addToDash = mkDefault true;
      traefik.enable = mkDefault true;
    };

    services.nginx = {
      enable = mkForce true;
      appendHttpConfig = "";
      virtualHosts."mc.morganlabs.dev" = {
        root = minecraftWebsite;
        listen = [
          {
            inherit port;
            addr = "127.0.0.1";
          }
        ];

        locations."/" = {
          tryFiles = "$uri $uri/ /index.html";
          index = "index.html";
        };

        locations."/tag/" = {
          extraConfig = ''
            location ~ ^/tag/([^/]+)/?$ {
              try_files /tag/$1/index.html =404;
            }

            try_files $uri $uri/ /tag/index.html /index.html;
            index index.html index.htm;
            autoindex on;
          '';
        };

        locations."/mods/" = {
          extraConfig = ''
            autoindex on;
            expires 1y;
          '';
        };

        locations."= /mods/lpsmp-optional-mods.zip" = mkZipAlias optionalModsZip;
      };
    };

    services.traefik.dynamicConfigOptions.http = mkIf cfg.traefik.enable (mkTraefikServices [
      {
        inherit port;
        subdomain = "mc";
        service = "mc-catalogue-website";
      }
    ]);
  };
}
