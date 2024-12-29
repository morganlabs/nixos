{
  config,
  lib,
  inputs,
  vars,
  pkgs,
  isDarwin,
  isLinux,
  ...
}:
with lib;
let
  cfg = config.modules.programs.kitty;

  homeManagerModule =
    mkIfElse isDarwin inputs.home-manager.darwinModules.home-manager
      inputs.home-manager.nixosModules.home-manager;

  platformConfigs = mkIfElse isLinux (import ./linux.nix { inherit lib cfg vars; }) (
    import ./darwin.nix { inherit lib cfg vars; }
  );
in
{
  imports = [
    homeManagerModule
    platformConfigs
  ];

  options.modules.programs.kitty = {
    enable = mkEnableOption "Enable programs.kitty";
    features.hyprland.enable = mkBoolOption "Enable Autostart, Window Rules and Binds for Hyprland" true;
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ kitty ];
    home-manager.users.${vars.user.username} = {
      programs.kitty = {
        enable = true;
        font.size = 12;
        settings = {
          window_padding_width = 8;
          enable_audio_bell = false;
        };

        shellIntegration.enableBashIntegration = config.programs.bash.enable;
        shellIntegration.enableZshIntegration = config.programs.zsh.enable;
        shellIntegration.enableFishIntegration = config.programs.fish.enable;
      };
    };
  };
}
