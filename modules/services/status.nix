{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.services.status;

  ports = {
    grafana = 3000;
    prometheus = 9090;
    blackbox = 9115;
  };
in
{
  options.modules.services.status = {
    enable = mkEnableOption "Enable services.status";
    traefik.enable = mkEnableOption "Enable Traefik routing";
  };

  config = mkIf cfg.enable {
    modules.services.status.traefik.enable = mkDefault true;

    services.prometheus.exporters.blackbox = {
      enable = true;
      configFile = pkgs.writeText "blackbox.yml" ''
        modules:
          http_2xx:
            prober: http
            timeout: 5s
            http:
              valid_http_versions: ["HTTP/1.1", "HTTP/2.0"]
              valid_status_codes: []  # Defaults to 2xx
              method: GET
              preferred_ip_protocol: "ip4"

          https_2xx:
            prober: http
            timeout: 5s
            http:
              valid_http_versions: ["HTTP/1.1", "HTTP/2.0"]
              valid_status_codes: []
              method: GET
              preferred_ip_protocol: "ip4"
              tls_config:
                insecure_skip_verify: false
      '';
    };

    # Prometheus scraping
    services.prometheus = {
      enable = true;

      scrapeConfigs = [
        {
          job_name = "blackbox-http";
          metrics_path = "/probe";
          params.module = [ "https_2xx" ]; # or "http_2xx" for http
          static_configs = [
            {
              targets = [
                "https://low-power-dash.morganlabs.dev"
                "https://morganlabs.dev"
              ];
            }
          ];
          relabel_configs = [
            {
              source_labels = [ "__address__" ];
              target_label = "__param_target";
            }
            {
              source_labels = [ "__param_target" ];
              target_label = "instance";
            }
            {
              target_label = "__address__";
              replacement = "localhost:${toString ports.blackbox}"; # Blackbox exporter address
            }
          ];
        }
      ];

      # Alert rules
      rules = [
        ''
          groups:
            - name: http_monitoring
              rules:
                - alert: WebsiteDown
                  expr: probe_success == 0
                  for: 2m
                  labels:
                    severity: critical
                  annotations:
                    summary: "{{ $labels.instance }} is down"
                    description: "HTTP probe failed for {{ $labels.instance }}"
        ''
      ];
    };

    # Alertmanager for notifications
    # services.prometheus.alertmanager = {
    #   enable = true;
    #   configuration = {
    #     route = {
    #       receiver = "discord";
    #       group_wait = "30s";
    #       group_interval = "5m";
    #       repeat_interval = "4h";
    #     };
    #     receivers = [{
    #       name = "discord";
    #       webhook_configs = [{
    #         url = "YOUR_DISCORD_WEBHOOK_URL";
    #         send_resolved = true;
    #       }];
    #     }];
    #   };
    # };

    # Grafana for visualization
    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = ports.grafana;
        };

        # Disable news/updates
        news.news_feed_enabled = false;

        # Clean up the UI
        analytics = {
          reporting_enabled = false;
          check_for_updates = false;
          check_for_plugin_updates = false;
        };

        # Disable other homepage sections (optional)
        dashboards = {
          default_home_dashboard_path = ""; # Or path to your default dashboard
        };
      };

      provision.datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://localhost:${toString ports.prometheus}";
          access = "proxy";
        }
      ];
    };

    services.traefik.dynamicConfigOptions.http = mkIf cfg.traefik.enable (mkTraefikServices [
      {
        service = "status";
        subdomain = "status";
        port = ports.grafana;
      }
    ]);
  };
}
