{
  config,
  lib,
  pkgs,
  tailnetName,
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
      default = "gensokyo.${tailnetName}";
      description = "Domain the synapse HTTP API is served from";
    };
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.matrix-synapse-registration-shared = {
      path = "/var/secrets/matrix-synapse-registration-shared";
      owner = "matrix-synapse";
      group = "matrix-synapse";
      mode = "0440";
    };
    systemd.services.tailscale-matrix-funnel = {
      description = "Expose Matrix Synapse via Tailscale Funnel";

      after = [
        "tailscaled.service"
        "matrix-synapse.service"
      ];

      requires = [ "tailscaled.service" ];
      bindsTo = [ "matrix-synapse.service" ];
      wantedBy = [ "matrix-synapse.service" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;

        ExecStart = [
          "${pkgs.tailscale}/bin/tailscale serve --bg localhost:${toString cfg.port}"
          "${pkgs.tailscale}/bin/tailscale funnel --bg localhost:${toString cfg.port}"
        ];

        ExecStop = [
          "${pkgs.tailscale}/bin/tailscale funnel --bg ${toString cfg.port} off"
          "${pkgs.tailscale}/bin/tailscale serve --bg ${toString cfg.port} off"
        ];
      };
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
          args = {
            database = "/var/lib/matrix-synapse/homeserver.db";
          };
        };
        listeners = singleton {
          inherit (cfg) port;
          bind_addresses = singleton "0.0.0.0";
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
