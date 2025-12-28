{
  config,
  lib,
  inputs,
  pkgs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.services.minecraft-server;

  ports = {
    minecraft = 25565;
    voice-chat = 24454;
  };

  catalogue = {
    path = ./catalogue/catalogue.lock.json;
    json = builtins.fromJSON (builtins.readFile catalogue.path);
    mods = catalogue.json.mods;
  };
in
{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers
    (import ./website.nix catalogue)
    (import ./mods.nix catalogue.mods)
    ./rcon.nix
  ];

  options.modules.services.minecraft-server = {
    enable = mkEnableOption "Enable services.minecraft-server";
    exposePorts = mkBoolOption "Expose ports" true;
    whitelist = mkTypeOption "attrs" "A list of players within the whitelist." { };

    config = {
      memory = mkIntOption "Memory to allocate (in GB)" 12;
    };
  };

  config = mkIf cfg.enable {
    modules.services.minecraft-server.mods.enable = mkDefault true;

    networking.firewall =
      with ports;
      mkIf cfg.exposePorts {
        allowedTCPPorts = [ minecraft ];
        allowedUDPPorts = [
          minecraft
          voice-chat
        ];
      };

    age.secrets = {
      minecraft-rcon-password.file = ../../../secrets/${vars.hostname}/minecraft-rcon-password.age;
      minecraft-rcon-user-password.file = ../../../secrets/${vars.hostname}/minecraft-rcon-user-password.age;
    };

    age-template.files."rcon-env" = {
      vars = {
        rconPassword = config.age.secrets.minecraft-rcon-password.path;
        rconUserPassword = config.age.secrets.minecraft-rcon-user-password.path;
      };
      content = ''
        RWA_RCON_PASSWORD=$rconPassword
        RWA_PASSWORD=$rconUserPassword
      '';
    };

    services.minecraft-servers = {
      enable = mkForce true;
      eula = mkForce true;
      dataDir = "/var/lib/minecraft";
      managementSystem.systemd-socket.enable = mkForce true;
      environmentFile = mkIfStr cfg.rcon.enable (toString config.age-template.files."rcon-env".path);

      servers.fabric = {
        inherit (cfg) whitelist;
        enable = mkForce true;
        autoStart = mkForce true;
        package = mkForce pkgs.fabricServers.fabric-1_21_1;

        operators = mkForce {
          Durabilitas = {
            uuid = "1459c26c-6296-49a9-adbf-2eec51b661b7";
            level = 4;
            bypassesPlayerLimit = true;
          };
        };

        jvmOpts =
          with cfg.config;
          mkForce "-Xms${toString memory}G -Xmx${toString memory}G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true";
        serverProperties = {
          motd = "The Low-Power Server Trying It's Best.";
          max-players = 5;
          white-list = true;
          enforce-whitelist = true;
          allow-cheats = false;
          server-port = ports.minecraft;

          force-gamemode = true;
          gamemode = 0; # Survival
          difficulty = 2; # Normal
          view-distance = 10;
          simulation-distance = 10;
          pause-when-empty-seconds = 60;
          max-tick-time = 60000;
          network-compression-threshold = 256;
        };
      };
    };

    systemd.services.minecraft-tps-watcher = mkForce {
      description = "Watch Minecraft logs and warn in chat on lag spikes";
      wantedBy = [ "multi-user.target" ];
      after = [ "minecraft-server-fabric.service" ];
      requires = [ "minecraft-server-fabric.service" ];

      serviceConfig = {
        Type = "simple";
        User = "root";
        Group = "root";

        ExecStart = pkgs.writeShellScript "minecraft-tps-watcher" ''
          set -eu

          # Follow the journal for the fabric server unit only
          ${pkgs.systemd}/bin/journalctl -fu minecraft-server-fabric.service |
          while IFS= read -r line; do
            case "$line" in
              *"Can't keep up!"*)
                echo "tellraw Durabilitas {\"text\":\"[SERVER/WARN] TPS Low\",\"color\":\"red\"}" | ${pkgs.sudo}/bin/sudo -u minecraft tee /run/minecraft/fabric.stdin
              ;;
            esac
          done
        '';

        Restart = "always";
        RestartSec = 5;
      };
    };
  };
}
