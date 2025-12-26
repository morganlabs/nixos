{ lib, ... }: {
  # Network (Hetzner uses static IP assignments, and we don't use DHCP here)
  networking.useDHCP = false;
  networking.interfaces."enp0s31f6".ipv4.addresses = [
    {
      address = "195.201.246.201";
      # Hetzner requires /32, see:
      #     https://docs.hetzner.com/robot/dedicated-server/network/net-config-debian-ubuntu/#ipv4.
      # NixOS automatically sets up a route to the gateway
      # (but only because we set "networking.defaultGateway.interface" below), see
      #     https://github.com/NixOS/nixops/pull/1032#issuecomment-2763497444
      prefixLength = 32;
    }
  ];
  networking.interfaces."enp0s31f6".ipv6.addresses = [
    {
      address = "2a01:4f8:231:72f::1";
      prefixLength = 64;
    }
  ];
  networking.defaultGateway = {
    address = "195.201.246.193";
    # Interface must be given for Hetzner networking to work, see comment above.
    interface = "enp0s31f6";
  };
  networking.defaultGateway6 = { address = "fe80::1"; interface = "enp0s31f6"; };
  networking.nameservers = [ "8.8.8.8" ];
}
