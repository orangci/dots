{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkIf
    singleton
    genAttrs
    getExe
    ;
  cfg = config.modules.services.productivity.opnform;
  publicUrl = "https://${cfg.subdomain}.${flakeSettings.domains.primary}";
  podman = getExe config.virtualisation.podman.package;

  # redis is reached by name, which only works on a non-default podman network
  network = "opnform";

  # the client and the api's php-fpm are published on loopback for caddy to route between
  clientPort = cfg.port - 1000;
  fpmPort = cfg.port - 2000;
  publicRoot = "/usr/share/nginx/html/public";

  # what the nginx in upstream's docker setup does: php-fpm gets every request to the api
  fpm = ''
    reverse_proxy localhost:${toString fpmPort} {
      transport fastcgi {
        root ${publicRoot}
        env SCRIPT_FILENAME ${publicRoot}/index.php
        env SCRIPT_NAME /index.php
        env REQUEST_URI {http.request.uri}
        env HTTPS on
      }
    }
  '';

  apiContainer = {
    image = "docker.io/jhumanj/opnform-api:latest";
    # pick up security fixes in :latest on restart instead of reusing a stale cached image
    pull = "newer";
    networks = singleton network;
    environmentFiles = singleton config.modules.security.sops.secrets.opnform-env.path;
    volumes = [
      "/var/lib/opnform/storage:/usr/share/nginx/html/storage:rw"
      "/run/postgresql:/run/postgresql:ro"
    ];
    environment = {
      APP_ENV = "production";
      APP_URL = publicUrl;
      FRONT_URL = publicUrl;
      LOG_CHANNEL = "errorlog";
      FILESYSTEM_DRIVER = "local";
      LOCAL_FILESYSTEM_VISIBILITY = "public";
      CACHE_DRIVER = "redis";
      QUEUE_CONNECTION = "redis";
      SESSION_DRIVER = "redis";
      REDIS_HOST = "opnform-redis";
      DB_CONNECTION = "pgsql";
      DB_HOST = "/run/postgresql";
      DB_DATABASE = "opnform";
      DB_USERNAME = "opnform";
      PHP_MEMORY_LIMIT = "1G";
      PHP_MAX_EXECUTION_TIME = "600";
      PHP_UPLOAD_MAX_FILESIZE = "64M";
      PHP_POST_MAX_SIZE = "64M";
    };
  };

  containers = [
    "opnform-api"
    "opnform-api-worker"
    "opnform-api-scheduler"
    "opnform-client"
    "opnform-redis"
  ];
  # the ones that talk to postgres
  databaseContainers = [
    "opnform-api"
    "opnform-api-worker"
    "opnform-api-scheduler"
  ];
in
{
  options.modules.services.productivity.opnform = lib.my.mkServerModule {
    name = "OpnForm";
    subdomain = "forms";
    glanceIcon = "sh:opnform";
  };

  config = mkIf cfg.enable {
    # needs APP_KEY (`base64:` followed by 32 random bytes in base64) and JWT_SECRET
    modules.security.sops.secrets.opnform-env.path = "/var/secrets/opnform-env";

    modules.services.databases.postgresql = {
      users = singleton "opnform";
      databases = singleton "opnform";
    };

    assertions = singleton {
      assertion = config.modules.services.databases.postgresql.enable;
      message = "OpnForm requires modules.services.databases.postgresql.enable to be set to true.";
    };

    # cloudflared, tailscale and the main domains all point at this port, so the routing lives here
    modules.services.infrastructure.caddy.virtualHosts.":${toString cfg.port}".extraConfig = ''
      handle /api/* {
        uri strip_prefix /api
        ${fpm}
      }
      @fpm path /open/* /local/temp/* /forms/assets/*
      handle @fpm {
        ${fpm}
      }
      handle {
        reverse_proxy localhost:${toString clientPort}
      }
    '';

    systemd.tmpfiles.rules = [
      "d /var/lib/opnform 0755 root root -"
      "d /var/lib/opnform/storage 0777 root root -"
      "d /var/lib/opnform/redis 0755 root root -"
    ];

    systemd.services = {
      podman-network-opnform = {
        description = "Podman network for OpnForm";
        wantedBy = [ "multi-user.target" ];
        before = map (name: "podman-${name}.service") containers;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          ${podman} network exists ${network} || ${podman} network create ${network}
        '';
      };

      postgresql = {
        before = map (name: "podman-${name}.service") databaseContainers;
        requiredBy = map (name: "podman-${name}.service") databaseContainers;
      };
    }
    // genAttrs (map (name: "podman-${name}") containers) (_: {
      requires = [ "podman-network-opnform.service" ];
      after = [ "podman-network-opnform.service" ];
    });

    virtualisation.oci-containers.containers = {
      opnform-redis = {
        image = "docker.io/library/redis:7";
        networks = singleton network;
        volumes = singleton "/var/lib/opnform/redis:/data";
      };

      opnform-api = apiContainer // {
        dependsOn = singleton "opnform-redis";
        ports = singleton "127.0.0.1:${toString fpmPort}:9000";
      };

      opnform-api-worker = apiContainer // {
        cmd = [
          "php"
          "artisan"
          "queue:work"
        ];
        dependsOn = [
          "opnform-api"
          "opnform-redis"
        ];
      };

      opnform-api-scheduler = apiContainer // {
        cmd = [
          "php"
          "artisan"
          "schedule:work"
        ];
        dependsOn = [
          "opnform-api"
          "opnform-redis"
        ];
      };

      opnform-client = {
        image = "docker.io/jhumanj/opnform-client:latest";
        networks = singleton network;
        dependsOn = singleton "opnform-api";
        ports = singleton "127.0.0.1:${toString clientPort}:3000";
        environment = {
          NUXT_PUBLIC_APP_URL = publicUrl;
          NUXT_PUBLIC_API_BASE = "${publicUrl}/api";
          NUXT_PRIVATE_API_BASE = "${publicUrl}/api";
        };
      };
    };
  };
}
