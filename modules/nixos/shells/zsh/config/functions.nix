{ pkgs, ... }:
with pkgs;
{
  programs.zsh.initExtra = ''
    function mkcdir() {
    	mkdir -p "$1"
    	cd "$1"
    }

    function nix() {
      if [[ "$1" == "develop" ]]; then
        ${nix}/bin/nix develop -c "$(which $SHELL)" "''${@:2}"
      else
        ${nix}/bin/nix "$@"
      fi
    }
  '';
}
