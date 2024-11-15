defaultPlugins: { pkgs, ... }:
{
  programs.firefox.profiles.personal = {
    name = "Personal";
    isDefault = true;
    extraConfig = builtins.readFile ../user.js;
    userChrome = import ../defaultChrome.nix;

    settings.extensions.autoDisableScopes = 0;
    extensions =
      with pkgs.nur.repos.rycee.firefox-addons;
      [
        sponsorblock
        youtube-shorts-block
      ]
      ++ defaultPlugins;

    search = {
      force = true;
      default = "Startpage";

      engines = {
        "Bing".metaData.hidden = true;
        "Google".metaData.alias = "@g"; # builtin engines only support specifying one additional alias

        "Startpage" = import ../engines/startpage.nix;
        "Nix Packages" = import ../engines/nixPackages.nix { inherit pkgs; };
        "NixOS Settings" = import ../engines/nixOSSettings.nix { inherit pkgs; };
        "Home Manager Settings" = import ../engines/homeManagerSettings.nix { inherit pkgs; };
      };
    };
  };
}
