{
  config,
  lib,
  pkgs,
  mkNixPak,
  ...
}:
with lib;
let
  cfg = config.modules.programs.microsoft-edge;

  sandboxed-edge = mkNixPak {
    config =
      { sloth, ... }:
      {
        app = {
          package = pkgs.microsoft-edge;
          binPath = "bin/microsoft-edge";
          # cmd = [
          #   "--enable-features=UseOzonePlatform"
          #   "--ozone-platform=wayland"
          #
          #   "--no-first-run"
          #   "--disable-dev-shm-usage" # Use /tmp instead of /dev/shm
          #   "--disable-background-timer-throttling"
          #   "--disable-backgrounding-occluded-windows"
          #   "--disable-renderer-accessibility" # Security
          # ];
        };

        dbus = {
          enable = true;
          policies = {
            "org.freedesktop.portal.*" = "talk";
            "org.freedesktop.Notifications" = "talk";
            "org.gnome.keyring" = "talk";
          };
        };

        flatpak.appId = "com.microsoft.Edge";

        bubblewrap = {
          network = true;
          # tmpfs = [ "/tmp" ];

          bind.rw = [
            (sloth.concat' sloth.homeDir "/Downloads")
            (sloth.concat' sloth.homeDir "/.config/microsoft-edge")
            (sloth.concat' sloth.homeDir "/.local/share/microsoft-edge")
            (sloth.env "XDG_RUNTIME_DIR")
            "/tmp/.X11-unix"
          ];

          bind.ro = [

            # D-Bus system bus socket
            "/run/dbus/system_bus_socket"
            "/etc"
          ];

          bind.dev = [
            "/dev/dri/card0"
            "/dev/dri/card1"
            "/dev/dri/renderD128"
          ];
        };
      };
  };
in
{
  options.modules.programs.microsoft-edge = {
    enable = mkEnableOption "Enable programs.microsoft-edge";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ sandboxed-edge.config.env ];
  };
}
