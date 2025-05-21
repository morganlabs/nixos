{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.zen-browser;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.zen-browser = {
    enable = mkEnableOption "Enable programs.zen-browser";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username} = {
      imports = [ inputs.zen-browser.homeModules.default ];

      programs.zen-browser = {
        enable = mkForce true;

        profiles.personal = {
          id = 0;
          name = mkForce "Personal";
          isDefault = mkForce true;
          extensions.packages = with inputs.firefox-addons.packages.${pkgs.system}; [ bitwarden ];

          settings = (import ./user.nix config) // {
            "browser.uiCustomization.state" = import ./layout.nix;
          };

          search = {
            force = mkForce true;
            default = "Startpage";

            engines = {
              "bing".metaData.hidden = true;
              "ddg".metaData.hidden = true;
              "ebay".metaData.hidden = true;
              "wikipedia".metaData.hidden = true;
              "google".metaData.alias = "@g";

              "Startpage" = import ./engines/startpage.nix;
              "Nix Packages" = import ./engines/nixPackages.nix { inherit pkgs; };
              "NixOS Settings" = import ./engines/nixOSSettings.nix { inherit pkgs; };
              "Home Manager Settings" = import ./engines/homeManagerSettings.nix;
              "Perplexity" = import ./engines/perplexity.nix;
            };
          };
        };
      };
    };
  };
}
