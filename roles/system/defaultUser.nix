{
  config,
  pkgs,
  user,
  lib,
  myLib,
  ...
}:
with lib;
with myLib;
let
  cfg = config.roles.defaultUser;
in
{
  options.roles.defaultUser = {
    enable = mkEnableOption "SSH";
    features.autologin.enable = mkOptionBool "Enable autologin" true;
    shell = mkOptionPackage "The user's shell" pkgs.zsh;
    packages = mkOptionListOf types.str "The user's packages" [ ];
    extra.groups = mkOptionListOf types.str "The groups that the user is present in" [
      "networkmanager"
      "wheel"
    ];
  };

  config = mkIf cfg.enable {
    # Ony autologin on the first TTY
    systemd.services."getty@tty1" = mkIf cfg.features.autologin.enable {
      overrideStrategy = "asDropin";
      serviceConfig.ExecStart = [
        ""
        "@${pkgs.util-linux}/sbin/agetty agetty --login-program ${config.services.getty.loginProgram} --autologin ${user.username} --noclear --keep-baud %I 115200,38400,9600 $TERM"
      ];
    };

    users.users.${user.username} = {
      inherit (cfg) packages shell;
      extraGroups = cfg.extra.groups;
      description = user.name;
      isNormalUser = true;
      ignoreShellProgramCheck = true;
    };
  };
}
