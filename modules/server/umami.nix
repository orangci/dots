{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkIf singleton;
  cfg = config.modules.server.umami;
in
{
  options.modules.server.umami = lib.my.mkServerModule {
    name = "Umami";
    glanceIcon = "auto-invert sh:umami";
  };

  config = mkIf cfg.enable {
    modules.server.postgresql = {
      users = singleton "umami";
      databases = singleton "umami";
    };
    modules.common.sops.secrets.umami-app-secret.path = "/var/secrets/umami-app-secret";
    systemd.services.postgresql.before = [ "podman-umami.service" ];
    systemd.services.postgresql.requiredBy = [ "podman-umami.service" ];

    assertions = lib.singleton {
      assertion = config.modules.server.postgresql.enable;
      message = "Umami requires modules.server.postgresql.enable to be set to true.";
    };

    virtualisation.oci-containers.containers.umami = {
      image = "ghcr.io/umami-software/umami:postgresql-latest";
      ports = [ "127.0.0.1:${toString cfg.port}:3000" ];
      environmentFiles = [ "/var/secrets/umami-app-secret" ];
      volumes = [ "/run/postgresql:/run/postgresql:ro" ];
      environment = {
        DATABASE_URL = "postgresql://umami@localhost/umami?host=/run/postgresql";
        TRACKER_SCRIPT_NAME = "data.js";
        COLLECT_API_ENDPOINT = "/api/postData";
        DATABASE_TYPE = "postgresql";
      };
    };
  };
}
