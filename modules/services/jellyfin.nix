{ config, lib, ... }:
with lib;
let
  cfg = config.modules.services.jellyfin;

  port = 8096;
in
{
  options.modules.services.jellyfin = {
    enable = mkEnableOption "Enable services.jellyfin";
    useMinIO = mkEnableOption "Use MinIO for storage";
    traefik.enable = mkEnableOption "Enable Traefik routing";

    hardwareAcceleration = {
      enable = mkEnableOption "Enable Hardware Acceleration";
      device = mkStringOption "Device path for hardware acceleration" "/dev/dri/renderD128";
      type = mkStringOption "Hardware acceleration type" "vaapi";
    };

    transcoding = {
      maxConcurrentStreams = mkIntOption "Max concurrent transcoding streams" 2;
      h264Crf = mkIntOption "Transcoding quality" 23;
      encodingPreset = mkStringOption "The encoding preset to use" "auto";
      enableToneMapping = mkBoolOption "Use tone mapping?" true;
      enableSubtitleExtraction = mkBoolOption "Burn-in subtitles?" true;
      enableHardwareEncoding = mkBoolOption "Enable hardware encoding?" false;
      deleteSegments = mkBoolOption "Delete transcoded segments?" true;
    };

    encodingCodecs = {
      hevc = mkBoolOption "Use HEVC encoding" false;
      av1 = mkBoolOption "Use AV1 encoding" false;
    };

    decodingCodecs = {
      vp9 = mkBoolOption "Use VP9 decoding" false;
      vp8 = mkBoolOption "Use VP8 decoding" false;
      vc1 = mkBoolOption "Use VC1 decoding" false;
      mpeg2 = mkBoolOption "Use MPEG2 decoding" false;
      hevcRExt12bit = mkBoolOption "Use HEVCRExt12Bit decoding" false;
      hevcRExt10bit = mkBoolOption "Use HEVCRex10Bit decoding" false;
      hevc10bit = mkBoolOption "Use HEVC 10-Bit decoding" false;
      hevc = mkBoolOption "Use HEVC decoding" false;
      h264 = mkBoolOption "Use H264 decoding" false;
      av1 = mkBoolOption "Use AV1 decoding" false;
    };
  };

  config = mkIf cfg.enable {
    modules.services = {
      jellyfin.traefik.enable = mkDefault true;

      minio = mkIf cfg.useMinIO {
        enable = mkForce true;
        buckets = mkAfter [
          {
            name = "media";
            policy = "private";
          }
        ];
      };

      s3fs = mkIf cfg.useMinIO {
        enable = mkForce true;
        mounts = mkAfter [
          {
            mountPoint = "/mnt/media";
            bucket = "media";
            uid = "jellyfin";
            gid = "jellyfin";
          }
        ];
      };
    };

    services.jellyfin = {
      enable = true;

      forceEncodingConfig = mkForce cfg.hardwareAcceleration.enable;
      hardwareAcceleration = mkIf cfg.hardwareAcceleration.enable {
        enable = mkForce true;
        device = mkForce cfg.hardwareAcceleration.device;
        type = mkForce cfg.hardwareAcceleration.type;
      };

      transcoding = cfg.transcoding // {
        hardwareEncodingCodecs = mkForce cfg.encodingCodecs;
        hardwareDecodingCodecs = mkForce cfg.decodingCodecs;
      };
    };

    services.traefik.dynamicConfigOptions = mkIf cfg.traefik.enable {
      http = {
        routers.jellyfin = {
          rule = "Host(`jellyfin.morganlabs.dev`)";
          entryPoints = [ "websecure" ];
          service = "jellyfin";
          tls = true;
        };

        services.jellyfin.loadBalancer.servers = [
          { url = "http://127.0.0.1:${toString port}"; }
        ];
      };
    };
  };
}
