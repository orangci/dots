{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;

  cfg = config.modules.server.bracket;
  postgresPort = 5432;
  dataDir = "/var/lib/bracket";
in
{
  options.modules.server.bracket = {
    enable = mkEnableOption "Enable Bracket";

    name = mkOption {
      type = types.str;
      default = "Bracket";
    };

    domain = mkOption {
      type = types.str;
      default = "bracket.orangc.net";
      description = "The domain for bracket to be hosted at";
    };

    port = mkOption {
      type = types.port;
      default = 8815;
      description = "The port for bracket to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.bracket-jwt-secret.path = "/var/secrets/bracket-jwt-secret";
    virtualisation.oci-containers.containers = {
      bracket-frontend = {
        image = "ghcr.io/evroon/bracket-frontend";
        ports = [
          "${toString cfg.port}:3000"
        ];
        environment = {
          NODE_ENV = "production";
          NEXT_PUBLIC_API_BASE_URL = "http://localhost:${toString (cfg.port - 1000)}";
          NEXT_PUBLIC_HCAPTCHA_SITE_KEY = "";
        };
      };

      bracket-backend = {
        image = "ghcr.io/evroon/bracket-backend";
        ports = [
          "${toString (cfg.port - 1000)}:8400"
        ];
        environmentFiles = [ "/var/secrets/bracket-jwt-secret" ];
        environment = {
          ENVIRONMENT = "PRODUCTION";
          PG_DSN = "postgresql://bracket_prod:bracket_prod@localhost:${toString postgresPort}/bracket_prod";
          CORS_ORIGINS = "https://${cfg.domain}";
        };
        volumes = [
          "./backend/static:/app/static"
        ];
        dependsOn = [ "postgres" ];
      };

      postgres = {
        image = "postgres";
        ports = [
          "${toString postgresPort}:${toString postgresPort}"
        ];
        environment = {
          POSTGRES_DB = "bracket_prod";
          POSTGRES_USER = "bracket_prod";
          POSTGRES_PASSWORD = "bracket_prod";
        };
        volumes = [
          "./postgres:/var/lib/postgresql/data"
        ];
      };
    };

    systemd.tmpfiles.rules = [
      "d ${dataDir}/backend/static 0700 1000 1000 -"
      "d ${dataDir}/postgres 0700 1000 1000 -"
    ];

    users.users.bracket = {
      isSystemUser = true;
      initialPassword = "a";
      group = "bracket";
    };

    users.groups.bracket = { };
  };
}
