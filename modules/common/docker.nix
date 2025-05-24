{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.common.docker;
in {
  options.modules.common.docker.enable = lib.mkEnableOption "Enable Docker containers";

  config = lib.mkIf cfg.enable {
    virtualisation.docker.enable = true;

    services.docker-containers = {
      glance = {
        image = "glanceapp/glance:latest";
        ports = ["7860:7860"];
        restart = "always";
      };

      ollama = {
        image = "ollama/ollama:latest";
        ports = ["11434:11434"];
        volumes = ["/var/lib/ollama:/root/.ollama"];
        restart = "always";
      };

      technitium = {
        image = "technitium/dns-server:latest";
        ports = ["5380:5380" "53:53/udp" "53:53"];
        volumes = ["/var/lib/technitium:/etc/dns"];
        restart = "always";
      };

      umami = {
        image = "ghcr.io/umami-software/umami:postgres-latest";
        ports = ["3000:3000"];
        environment = {
          DATABASE_URL = "postgresql://umami:password@umami-db:5432/umami";
        };
        dependsOn = ["umami-db"];
        restart = "always";
      };

      "umami-db" = {
        image = "postgres:15";
        environment = {
          POSTGRES_DB = "umami";
          POSTGRES_USER = "umami";
          POSTGRES_PASSWORD = "password";
        };
        volumes = ["/var/lib/umami-db:/var/lib/postgresql/data"];
        restart = "always";
      };

      ntfy = {
        image = "binwiederhier/ntfy:latest";
        ports = ["2586:80"];
        volumes = ["/var/lib/ntfy:/etc/ntfy"];
        restart = "always";
      };

      gitea = {
        image = "gitea/gitea:latest";
        ports = ["3001:3000" "222:22"];
        volumes = ["/var/lib/gitea:/data"];
        restart = "always";
      };

      searxng = {
        image = "searxng/searxng:latest";
        ports = ["8080:8080"];
        restart = "always";
      };

      vaultwarden = {
        image = "vaultwarden/server:latest";
        ports = ["8222:80"];
        volumes = ["/var/lib/vaultwarden:/data"];
        restart = "always";
      };

      twofauth = {
        image = "2fauth/2fauth:latest";
        ports = ["8082:80"];
        volumes = ["/var/lib/2fauth:/2fauth/storage"];
        restart = "always";
      };

      chibisafe = {
        image = "chibisafe/chibisafe:latest";
        ports = ["9999:8080"];
        volumes = ["/var/lib/chibisafe:/mnt/data"];
        environment = {DB_DIALECT = "sqlite";};
        restart = "always";
      };

      coolify = {
        image = "coollabsio/coolify:latest";
        ports = ["3002:3000"];
        volumes = ["/var/lib/coolify:/app/data"];
        restart = "always";
      };
    };
  };
}
