{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.modules.bundles.desktop;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.bundles.desktop = {
    enable = mkEnableOption "Enable bundles.desktop";
  };

  config = mkIf cfg.enable {
    modules.programs = {
      _1password.enable = mkDefault true;
      firefox.enable = mkDefault true;
      element.enable = mkDefault true;
      kitty.enable = mkDefault true;
      obsidian.enable = mkDefault true;
      signal.enable = mkDefault true;
      spotify.enable = mkDefault true;
      nextcloud-client.enable = mkDefault true;
    };
  };
}
