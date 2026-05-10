{
  config,
  lib,
  flakeSettings,
  ...
}:

let
  inherit (lib)
    mkIf
    mkOption
    singleton
    types
    ;

  cfg = config.modules.server.matrix-synapse;
in
{
  options.modules.server.matrix-synapse =
    lib.my.mkServerModule {
      name = "Matrix Synapse";
      subdomain = "matrix";
      glanceIcon = "auto-invert sh:matrix";
    }
    // {
      serverName = mkOption {
        type = types.str;
        default = "orangc.net";
        description = "Matrix server name (used in MXIDs)";
      };
    };

  config = mkIf cfg.enable {
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
        public_baseurl = "https://${cfg.subdomain}.${flakeSettings.domains.primary}/";
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
