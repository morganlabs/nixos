cfg:
{ lib, ... }:
with lib;
mkIf cfg.enable {
  networking = {
    networkmanager.dns = mkForce "none";
    nameservers = mkForce [
      "76.76.2.2#ControlD"
      "76.76.10.2#ControlD"
      "2606:1a40::2#ControlD"
      "2606:1a40:1::2#ControlD"
    ];
  };

  services.resolved = {
    enable = mkForce true;
    dnssec = mkForce "true";
    domains = mkForce [ "~." ];
    llmnr = mkForce "true";
    extraConfig = mkForce ''
      DNSOverTLS=opportunistic
      MulticastDNS=resolve
    '';
  };
}
