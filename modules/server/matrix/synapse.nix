{
  config,
  lib,
  pkgs,
  flakeSettings,
  ...
}:

let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    singleton
    types
    ;

  cfg = config.modules.server.matrix.synapse;
in
{
  options.modules.server.matrix.synapse = {
    enable = mkEnableOption "Enable Matrix Synapse";

    name = mkOption {
      type = types.str;
      default = "Matrix Synapse";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "Port synapse listens on";
    };

    serverName = mkOption {
      type = types.str;
      default = "orangc.net";
      description = "Matrix server name (used in MXIDs)";
    };

    apiDomain = mkOption {
      type = types.str;
      default = "matrix.${flakeSettings.domains.primary}";
      description = "Domain the synapse HTTP API is served from";
    };
  };

  config = mkIf cfg.enable {
    modules.server = {
      cloudflared.ingress."matrix.${flakeSettings.domains.primary}" =
        "http://localhost:${toString cfg.port}";
      caddy.virtualHosts = {
        "matrix.${flakeSettings.domains.primary}".extraConfig =
          "reverse_proxy localhost:${toString cfg.port}";
        "https://matrix.${flakeSettings.domains.tailnet}".extraConfig = ''
          bind tailscale/matrix
          reverse_proxy localhost:${toString cfg.port}
        '';
      };
      glance.monitoredSites = singleton {
        url = "https://matrix.${flakeSettings.domains.tailnet}";
        title = "Matrix";
        icon = "sh:matrix";
      };
    };
    modules.common.sops.secrets.matrix-synapse-registration-shared = {
      path = "/var/secrets/matrix-synapse-registration-shared";
      owner = "matrix-synapse";
      group = "matrix-synapse";
      mode = "0440";
    };
    services.matrix-synapse = {
      enable = true;
      settings = {
        server_name = cfg.serverName;
        public_baseurl = "https://${cfg.apiDomain}/";
        enable_registration = false;
        report_stats = false;
        registration_shared_secret =
          config.modules.common.sops.secrets.matrix-synapse-registration-shared.path;
        database = {
          name = "sqlite3";
          args.database = "/var/lib/matrix-synapse/homeserver.db";
        };
        listeners = singleton {
          inherit (cfg) port;
          bind_addresses = singleton "127.0.0.1";
          type = "http";
          tls = false;
          resources = singleton {
            names = [
              "client"
              "federation"
            ];
            compress = true;
          };
        };
      };
    };
  };
}
