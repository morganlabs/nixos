{
  config,
  lib,
  inputs,
  pkgs,
  vars,
  ...
}:
let
  cfg = config.modules.programs.cider2;

  # https://git.nvds.be/NicolaiVdS/Nix-Cider2/src/branch/main/default.nix
  cider2 =
    let
      pname = "Cider";
      version = "2.6.0";
      src = pkgs.requireFile {
        url = "https://cidercollective.itch.io/cider";
        name = "Cider-linux-x64.AppImage";
        sha256 = "abdba55d885ae4f4996d867fa313af1af2b95c69f44e50063329a3bb97d7c265";
      };
    in
    with pkgs;
    appimageTools.wrapType2 {
      inherit pname version src;

      extraInstallCommands =
        let
          contents = appimageTools.extract { inherit pname version src; };
        in
        ''
          install -m 444 -D ${contents}/${pname}.desktop -t $out/share/applications
          substituteInPlace $out/share/applications/${pname}.desktop \
            --replace 'Exec=AppRun' 'Exec=${pname}'
          cp -r ${contents}/usr/share/icons $out/share
        '';

      meta = {
        description = "A new look into listening and enjoying Apple Music in style and performance.";
        homepage = "https://cider.sh";
        platforms = [ "x86_64-linux" ];
      };
    };
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.cider2 = {
    enable = mkEnableOption "Enable programs.cider2";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cider2 ];

    home-manager.users.${vars.user.username} = {
      home.file.".config/sh.cider.electron/spa-config.yml".text =
        import ./config.nix config.stylix.base16Scheme;
      wayland.windowManager.hyprland.settings = mkIfList cfg.features.hyprland.enable {
        exec-once = [ "${cider2}/bin/cider" ];
        windowrulev2 = [ "workspace special:s3, class:(cider)" ];
      };
    };
  };
}
