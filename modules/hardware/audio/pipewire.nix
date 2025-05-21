{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.hardware.audio.pipewire;

  mkRename = node-name: rename-to: ''
    {
      matches = [
        {
          node.name = "${node-name}"
        }
      ]
      actions = {
        "update-props" = {
          "node.nick" = "${rename-to}"
          "node.description" = "${rename-to}"
        }
      }
    }
  '';
in
{
  options.modules.hardware.audio.pipewire = {
    enable = mkEnableOption "Enable services.pipewire";
  };
  config = mkIf cfg.enable {
    # TODO: Figure out why the hell AirPlay/2 isn't AirPlay-ing

    # Set microphone boost to 0 on boot
    # Why the hell isn't there just a setting for this :(
    systemd.services.set-mic-boost = {
      description = "Set microphone boost";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.alsa-utils}/bin/amixer -c 0 set 'Mic Boost' 2";
      };
    };

    environment = {
      systemPackages = with pkgs; [ pulseaudio ];

      etc."wireplumber/wireplumber.conf.d/51-rename-sinks.conf".text = ''
        monitor.alsa.rules = [
          ${mkRename "alsa_output.pci-0000_00_1f.3.analog-stereo" "Internal Speakers/Headphones"}
          ${mkRename "alsa_input.pci-0000_00_1f.3.analog-stereo" "Internal Microphone"}
        ]
      '';
    };

    services.pipewire = {
      enable = mkForce true;

      pulse.enable = mkForce true;
      jack.enable = mkForce true;
      alsa = {
        enable = mkForce true;
        support32Bit = mkForce true;
      };

      wireplumber = {
        enable = mkForce true;
      };
    };
  };
}

# {
#   config,
#   lib,
#   pkgs,
#   ...
# }:
# with lib;
# let
#   cfg = config.modules.hardware.audio.pipewire;
#
#   mkRename = nodeName: renameTo: ''
#     {
#       {
#         matches = [ { node.name = "${nodeName}" } ]
#         actions = {
#           "update-props" = {
#             "node.nick" = "${renameTo}"
#             "node.description" = "${renameTo}"
#           }
#         }
#       }
#     }
#   '';
# in
# {
#   options.modules.hardware.audio.pipewire = {
#     enable = mkEnableOption "Enable services.pipewire";
#   };
#   config = mkIf cfg.enable {
#     # TODO: Figure out why the hell AirPlay/2 isn't AirPlay-ing
#
#     environment = {
#       systemPackages = with pkgs; [ pulseaudio ];
#
#       etc."wireplumber/wireplumber.conf.d/51-rename-sinks.conf".text = ''
#         monitor.alsa.rules = [
#           ${mkRename "alsa_output.pci-0000_00_1f.3.analog-stereo" "Internal Speakers/Headphones"}
#           ${mkRename "alsa_input.pci-0000_00_1f.3.analog-stereo" "Internal Microphone"}
#         ]
#       '';
#     };
#
#     services.pipewire = {
#       enable = mkForce true;
#
#       pulse.enable = mkForce true;
#       jack.enable = mkForce true;
#       alsa = {
#         enable = mkForce true;
#         support32Bit = mkForce true;
#       };
#
#       wireplumber = {
#         enable = mkForce true;
#       };
#     };
#   };
# }
