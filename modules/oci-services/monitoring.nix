{ config, lib, ... }:

with lib;
let
  cfg = config.oci-services.monitoring;
  ports = {
    grafana = 2342;
    prometheus = 9000;
    node_exporter = 9100;
  };
in
{
  options.oci-services.monitoring = {
    enable = mkEnableOption "monitoring";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [ 80 443 ];
    };

    services.cadvisor.enable = true;
    services.prometheus = {
      exporters = {
        node = {
          enable = true;
          enabledCollectors = mkDefault [ "systemd" ];
          port = ports.node_exporter;
        };
      };
    };

    services.grafana.enable = true;
    services.grafana.settings.server = {
      http_port = ports.grafana;
      http_addr = "127.0.0.1";
    };

    services.prometheus = {
      enable = true;
      port = ports.prometheus;
      retentionTime = mkDefault "7d";
      globalConfig = {
        scrape_timeout = mkDefault "10s";
        scrape_interval = mkDefault "30s";
      };
      scrapeConfigs = [
        {
          job_name = "node_exporter";
          static_configs = [{
            targets = [ 
              "127.0.0.1:${toString config.services.prometheus.exporters.node.port}"
            ];
          }];
        }
        {
          job_name = "cadvisor";
          static_configs = [{
            targets = [ 
              "127.0.0.1:${toString config.services.cadvisor.port}"
            ];
          }];
        }
      ];
    };

    services.nginx.virtualHosts."grafana.*" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
        '';
      };
    };

    services.nginx.virtualHosts."prometheus.*" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.prometheus.port}";
      };
    };
  };
}
