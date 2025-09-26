{
  config,
  lib,
  host,
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
      default = "grafana.orangc.net";
      description = "The domain for grafana to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.grafana-to-ntfy-bauth-pass.path =
      "/var/secrets/grafana-to-ntfy-bauth-pass";
    modules.common.sops.secrets.speedtest-api-key.path = "/var/secrets/speedtest-api-key";
    services.prometheus = {
      enable = true;
      enableReload = true;
      port = cfg.port - 1000;
      exporters = {
        node = {
          enable = true;
          enabledCollectors = singleton "systemd";
          port = cfg.port - 2000;
        };
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
        security.cookie_secure = true;
        users.default_language = "en-GB";
      };
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
