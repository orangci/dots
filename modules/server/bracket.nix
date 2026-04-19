{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkIf
    ;

  cfg = config.modules.server.bracket;
  dataDir = "/var/lib/bracket";
in
{
  options.modules.server.bracket = lib.my.mkServerModule { name = "Bracket"; };

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
          "127.0.0.1:${toString (cfg.port - 1000)}:8400"
        ];
        environmentFiles = [ "/var/secrets/bracket-jwt-secret" ];
        environment = {
          ENVIRONMENT = "PRODUCTION";
          PG_DSN = "postgresql://bracket_prod:bracket_prod@localhost:${toString (cfg.port - 2000)}/bracket_prod";
          CORS_ORIGINS = "https://${cfg.subdomain}.${flakeSettings.domains.primary}";
        };
        volumes = [
          "./backend/static:/app/static"
        ];
        dependsOn = [ "postgres" ];
      };

      postgres = {
        image = "postgres";
        ports = [
          "127.0.0.1:${toString (cfg.port - 2000)}:${toString (cfg.port - 2000)}"
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
