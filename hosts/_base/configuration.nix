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
    # registry.nixpkgs.flake = pkgs;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
}
