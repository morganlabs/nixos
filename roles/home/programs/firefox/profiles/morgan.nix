{ pkgs }:
{
  name = "Morgan";
  isDefault = true;
  extraConfig = builtins.readFile ../user.js;

  settings.extensions.autoDisableScopes = 0;
  extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    onepassword-password-manager
    ublock-origin
    sponsorblock
    youtube-shorts-block
  ];

  search = {
    force = true;
    default = "Startpage";

    engines = {
      "Bing".metaData.hidden = true;
      "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias

      "Startpage" = import ../searchEngines/startpage.nix;
      "Nix Packages" = import ../searchEngines/nixPackages.nix { inherit pkgs; };
      "NixOS Settings" = import ../searchEngines/nixOSSettings.nix { inherit pkgs; };
      "Home Manager Settings" = import ../searchEngines/homeManagerSettings.nix { inherit pkgs; };
    };
  };
}
