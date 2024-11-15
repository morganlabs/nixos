{ inputs, ... }: 
with inputs; {
  imports = [
    ./desktop/hyprland.nix

    ./decoration/stylix
    stylix.nixosModules.stylix
  ];
}
