{
  config,
  lib,
  vars,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.programs.firefox;
in
{
  imports = [
    ./profiles/personal.nix
  ];

  options.modules.programs.firefox = {
    enable = mkEnableOption "Enable programs.firefox";
  };

  config = mkIf cfg.enable {
    modules.programs.firefox = {
      profiles = {
        personal.enable = mkDefault true;
      };
    };

    home-manager.users.${vars.user.username} = {
      imports = [ inputs.arkenfox.hmModules.arkenfox ];

      programs.firefox = {
        enable = mkForce true;
        languagePacks = mkBefore [ "en-GB" ];
        arkenfox = {
          enable = true;
          version = "master";
        };
      };
    };
  };
}
