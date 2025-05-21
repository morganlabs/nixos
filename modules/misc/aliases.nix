{
  config,
  lib,
  inputs,
  vars,
  ...
}:
with lib;
let
  cfg = config.modules.misc.aliases;

  aliases = {
    mkdir = mkForce "mkdir -p";
    c = mkForce "clear";
    e = mkForce "exit";
    src = mkForce "source $HOME/.zshrc";
  };
in
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.misc.aliases = {
    enable = mkEnableOption "Enable misc.aliases";
  };

  config = mkIf cfg.enable {
    home-manager.users.${vars.user.username}.home.shellAliases = mkBefore aliases;
  };
}
