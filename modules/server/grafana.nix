{
  config,
  lib,
  host,
  flakeSettings,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    singleton
    ;
  cfg = config.modules.server.grafana;
in
{
  options.modules.server.grafana = {
    enable = mkEnableOption "Enable grafana";

    glance.enable = mkEnableOption "Enable visibility for this service in the Glance dashboard";
    cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
    internalTailscaleDomain.enable = mkEnableOption "Enable an internal, http .home domain for this service";
    ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

    name = mkOption {
      type = types.str;
      default = "Grafana";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for grafana to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "grafana.${flakeSettings.primaryDomain}";
      description = "The domain for grafana to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.grafana-to-ntfy-bauth-pass.path =
      "/var/secrets/grafana-to-ntfy-bauth-pass";
    modules.common.sops.secrets.grafana-secret-key.path = "/var/secrets/grafana-secret-key";
    modules.common.sops.secrets.speedtest-api-key.path = "/var/secrets/speedtest-api-key";
    services.prometheus = {
      enable = true;
      enableReload = true;
      port = cfg.port - 1000;
      exporters.node = {
        enable = true;
        enabledCollectors = [
          "ethtool"
          "softirqs"
          "systemd"
          "tcpstat"
          "wifi"
          "cpu"
          "diskstats"
          "filesystem"
          "loadavg"
          "meminfo"
          "netdev"
          "stat"
          "time"
          "uname"
          "vmstat"
        ];
        port = cfg.port - 2000;
      };
      scrapeConfigs = singleton {
        job_name = host;
        static_configs = singleton {
          targets = [ "127.0.0.1:${toString config.services.prometheus.exporters.node.port}" ];
        };
      };
    };
    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_port = cfg.port;
          enable_gzip = true;
          inherit (cfg) domain;
        };
        security = {
          cookie_secure = true;
          secret_key = config.modules.common.sops.secrets.grafana-secret-key.path;
          admin_email = "grafana@${flakeSettings.emailDomain}";
        };
        users.default_language = "en-GB";
      };

      provision = {
        enable = true;
        datasources.settings.datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            access = "proxy";
            url = "http://127.0.0.1:${toString config.services.prometheus.port}";
            isDefault = true;
          }
        ];
      };

      declarativePlugins = with pkgs.grafanaPlugins; [
        bsull-console-datasource
        fetzerch-sunandmoon-datasource
        grafana-clock-panel
        grafana-github-datasource
        grafana-piechart-panel
        grafana-worldmap-panel
      ];
    };
    modules.server.ntfy.topics = singleton {
      name = "grafana";
      users =
        let
          users = config.modules.server.ntfy.users or [ ];
        in
        lib.map (user: user.username) users;
      permission = "read-only";
    };
    services.grafana-to-ntfy = mkIf config.modules.server.ntfy.enable {
      enable = true;
      settings = {
        ntfyUrl = "https://${config.modules.server.ntfy.domain}/grafana";
        bauthUser = "grafana";
        bauthPass = config.modules.common.sops.secrets.grafana-to-ntfy-bauth-pass.path;
        ntfyBAuthUser = "grafana";
        ntfyBAuthPass = config.modules.common.sops.secrets.grafana-to-ntfy-bauth-pass.path;
      };
    };
  };
}
