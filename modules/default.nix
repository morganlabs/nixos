{
  imports = [
    ./core.nix

    ./bootloader/systemd-boot.nix

    ./hardware/bluetooth.nix

    ./networking

    ./services/ssh

    ./programs/git.nix

  ];
}
