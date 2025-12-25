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

  internalPort = 4587;

  # Mod filters & fetchers
  filterMods =
    roles: if roles == [ ] then catalogue.mods else filter (m: elem m.role roles) catalogue.mods;

  allModsList = filterMods [ ];
  serverModsList = filterMods [
    "server"
    "both-required"
    "both-optional"
  ];
  recommendedModsList = filterMods [
    "client-required"
    "client-optional"
    "both-required"
    "both-optional"
  ];
  requiredModsList = filterMods [
    "client-required"
    "both-required"
  ];

  mkSymlinkScript =
    modsList:
    concatMapStringsSep "\n" (
      m:
      let
        fname = "${m.role}-${lib.replaceStrings [ " " ] [ "_" ] m.title}-${m.id}.jar";
        drv = pkgs.fetchurl {
          url = m.file;
          sha512 = m.sha512;
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

  allModsZip = mkModZip "all-mods" allModsList;
  serverModsZip = mkModZip "server-mods" serverModsList;
  recommendedModsZip = mkModZip "recommended-mods" recommendedModsList;
  requiredModsZip = mkModZip "required-mods" requiredModsList;

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
      virtualHosts."low-power-server.morganlabs.dev" = {
        root = minecraftWebsite;
        listen = [
          {
            addr = "127.0.0.1";
            port = internalPort;
          }
        ];

        locations."/" = {
          tryFiles = "$uri $uri/ /index.html";
          index = "index.html";
        };

        locations."/tag/" = {
          extraConfig = ''
            # Clean URLs: /tag/qol → /tag/qol/index.html (NO trailing slash)
            location ~ ^/tag/([^/]+)/?$ {
              try_files /tag/$1/index.html =404;
            }

            # Directory index + SPA fallback
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

        locations."= /mods/all-mods.zip" = mkZipAlias allModsZip;
        locations."= /mods/server-mods.zip" = mkZipAlias serverModsZip;
        locations."= /mods/recommended-mods.zip" = mkZipAlias recommendedModsZip;
        locations."= /mods/required-mods.zip" = mkZipAlias requiredModsZip;
      };
    };

    services.traefik.dynamicConfigOptions = mkIf cfg.traefik.enable {
      http = {
        routers.minecraft-server-website = {
          rule = "Host(`low-power.morganlabs.dev`)";
          entryPoints = [ "websecure" ];
          service = "minecraft-server-website";
          tls = true;
        };

        services.minecraft-server-website.loadBalancer.servers = [
          { url = "http://127.0.0.1:${toString internalPort}"; }
        ];
      };
    };
  };
}
