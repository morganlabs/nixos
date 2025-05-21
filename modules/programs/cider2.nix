{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.cider2;
  cider2 =
    let
      pname = "Cider";
      version = "3.0.2";
      src = pkgs.fetchurl {
        url = "file:///etc/nixos/.apps";
        name = "cider-v${version}-linux-x64.AppImage";
        sha256 = "5d506132048d240613469c79186ae8b5e78ec7400f233b8709b7fe908353d9e5";
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
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cider2 ];

    home-manager.users.${vars.user.username} = {
    };
  };
}
