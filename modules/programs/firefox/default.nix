{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.firefox;

  defaultPlugins = with pkgs.nur.repos.rycee.firefox-addons; [
    onepassword-password-manager
    ublock-origin
    clearurls
    facebook-container
    don-t-fuck-with-paste
  ];
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.firefox = {
    enable = mkEnableOption "Enable programs.firefox";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      imports = [ (import ./profiles/personal defaultPlugins) ];
      programs.firefox = {
        enable = true;
        package = inputs.firefox-nightly.packages.${pkgs.system}.firefox-nightly-bin;
      };
    };
  };
}
