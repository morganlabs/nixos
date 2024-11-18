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
  nightly = inputs.firefox-nightly.packages.${pkgs.system}.firefox-nightly-bin;

  defaultPlugins = with pkgs.nur.repos.rycee.firefox-addons; [
    onepassword-password-manager
    ublock-origin
    clearurls
    facebook-container
    don-t-fuck-with-paste
    profile-switcher
    sponsorblock
    youtube-shorts-block
  ];
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.firefox = {
    enable = mkEnableOption "Enable programs.firefox";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      imports = [
        (import ./profiles/personal.nix defaultPlugins)
        (import ./profiles/college.nix defaultPlugins)
        (import ./profiles/work.nix defaultPlugins)
      ];

      programs.firefox = {
        enable = true;
        package = nightly;
      };

      wayland.windowManager.hyprland.settings = {
        exec-once = [ "[workspace 2 silent] ${nightly}/bin/firefox-nightly" ];
        windowrulev2 = [ "workspace 2, class:(firefox-nightly)" ];
      };
    };
  };
}
