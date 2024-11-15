{ inputs, ... }: {
  imports = with inputs; [
    ./desktop/hyprland

    ./programs/nvim
    nixvim.homeManagerModules.nixvim
    ./programs/zsh
    ./programs/firefox
    ./programs/git.nix
    ./programs/kitty.nix
  ];
}
