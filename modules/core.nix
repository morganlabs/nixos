{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.core;
in
{
  options.modules.core = {
    enable = mkEnableOption "Enable core";
  };

  config = mkIf cfg.enable {
    modules = {
      bootloader.systemd-boot.enable = mkDefault true;

      programs = {
        git.enable = mkDefault true;
        nvim.enable = mkDefault true;
        stylix.enable = mkDefault true;
      };

      networking.enable = mkDefault true;
      hardware.bluetooth.enable = mkDefault true;
      services.ssh.enable = mkDefault true;
    };

    services.dbus.implementation = mkForce "dbus"; # Fix weird bug (nixos-rebuild hangs with broker?)
    networking.hostName = vars.hostname;

    environment.systemPackages = [ inputs.agenix.packages.${vars.system}.default ];

    age = {
      identityPaths = mkBefore [ "/root/.ssh/id_ed25519" ];
      secrets = {
        user-password.file = mkForce ../secrets/${vars.hostname}/user-password.age;
        root-password.file = mkForce ../secrets/${vars.hostname}/root-password.age;
      };
    };

    console.keyMap = "uk";
    time.timeZone = "Europe/London";
    services.xserver.xkb.layout = "gb";
    i18n = {
      defaultLocale = "en_GB.UTF-8";
      extraLocaleSettings = {
        LC_ADDRESS = "en_GB.UTF-8";
        LC_IDENTIFICATION = "en_GB.UTF-8";
        LC_MEASUREMENT = "en_GB.UTF-8";
        LC_MONETARY = "en_GB.UTF-8";
        LC_NAME = "en_GB.UTF-8";
        LC_NUMERIC = "en_GB.UTF-8";
        LC_PAPER = "en_GB.UTF-8";
        LC_TELEPHONE = "en_GB.UTF-8";
        LC_TIME = "en_GB.UTF-8";
      };
    };

    users = {
      # Allows me to enforce hashedPasswordFile
      mutableUsers = mkDefault false;

      users = {
        root.hashedPasswordFile = mkForce config.age.secrets.root-password.path;
        ${vars.user.username} = {
          isNormalUser = mkForce true;
          description = mkForce vars.user.fullName;
          extraGroups = mkBefore [ "wheel" ];
          openssh.authorizedKeys.keys = mkBefore [ vars.sshKey ];
          hashedPasswordFile = mkForce config.age.secrets.user-password.path;
        };
      };
    };

    home-manager.backupFileExtension = "bak";

    nix = {
      optimise.automatic = mkForce true;
      gc = {
        automatic = mkForce true;
        dates = mkForce [ "daily" ];
        options = mkBefore "--delete-older-than 16d";
        persistent = mkForce true;
      };
      settings = {
        sandbox = mkForce true;
        max-jobs = mkForce "auto";
        cores = mkForce 0;
        trusted-users = mkBefore [ vars.user.username ];
        experimental-features = mkBefore [
          "nix-command"
          "flakes"
        ];
      };
    };
  };
}
