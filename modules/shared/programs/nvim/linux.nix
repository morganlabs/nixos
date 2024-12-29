{ cfg, lib }:
with lib;
{
  config = mkIf cfg.enable {
    environment = {
      sessionVariables.EDITOR = "nvim";
      systemPackages = with pkgs; [ wl-clipboard ];
    };

    stylix.targets.nixvim = mkIf isLinux {
      enable = true;
      transparentBackground = {
        main = true;
        signColumn = true;
      };
    };
  };
}
