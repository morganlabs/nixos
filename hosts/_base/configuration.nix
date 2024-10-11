{
  hostname,
  pkgs,
  ...
}:
{
  imports = [
    ../../roles/system
  ];

  networking.hostName = hostname;
  environment.systemPackages = with pkgs; [ git ];

  roles = {
    desktop.hyprland.enable = true;
    defaultUser.enable = true;

    bootloader.grub.enable = true;
    sound = {
      pipewire.enable = true;
      noisetorch.enable = true;
    };

    misc = {
      defaultFonts.enable = true;
      security.enable = true;
      i18n.enable = true;
    };

    connectivity = {
      networkmanager.enable = true;
      bluetooth.enable = true;
      firewall.enable = true;
      ssh.enable = true;
    };

    security = {
      keyring.enable = true;
    };

    programs = {
      _1password.enable = true;
    };
  };

  hardware.graphics.enable = true;

  nix = {
    settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };
}
