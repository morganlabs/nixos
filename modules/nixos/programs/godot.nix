{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
let
  cfg = config.modules.programs.godot;
in
with lib;
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.programs.godot = {
    enable = mkEnableOption "Enable programs.godot";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ godot_4 ];
  };
}
