{
  imports = [
    ./basic.nix

    ./windows/movement.nix
    ./windows/toggle-floating.nix

    ./workspaces/regular/navigation.nix
    ./workspaces/special/navigation.nix

    ./programs/kitty.nix
    ./programs/rofi.nix

    ./functions/media.nix
    ./functions/volume.nix
    ./functions/brightness.nix
  ];
}
