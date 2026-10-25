{
  config,
  lib,
  sysadmin,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    types
    singleton
    mkEnableOption
    ;
  cfg = config.modules.services.misc.reviewbot;
in
{
  options.modules.services.misc.reviewbot = {
    enable = mkEnableOption "the is-a.dev Reviewbot GitHub bot";

    port = mkOption {
      type = types.port;
      default = 8801;
      description = "The local port the bot's webhook listener is published on.";
    };

    config = mkOption {
      type = types.attrsOf types.str;
      default = { };
      example = {
        SENTRY = "https://reimu@sentry.example/1";
      };
      description = "Extra environment variables passed to Reviewbot. Secrets belong in the sops environment file instead.";
    };

    webhook = {
      expose = mkEnableOption "routing GitHub's webhook deliveries to the bot through the Cloudflare Tunnel";
      subdomain = mkOption {
        type = types.str;
        default = "reviewbot";
        description = "The subdomain GitHub delivers webhooks to. The App's webhook URL is `https://<subdomain>.<domain>/api/webhook`.";
      };
    };
  };

  config = mkIf cfg.enable {
    # APP_ID, WEBHOOK_SECRET, INSTALLATION_ID and (optionally) SENTRY
    modules.security.sops.secrets.reviewbot-env.path = "/var/secrets/reviewbot-env";
    modules.security.sops.secrets.reviewbot-private-key.path = "/var/secrets/reviewbot-private-key.pem";
    # owned by the sysadmin so the database can be restored or inspected without root
    systemd.tmpfiles.rules = singleton "d /var/lib/reviewbot 0755 ${sysadmin.username} root -";

    # a bot has no site to show: no caddy, glance or ntfy entries, only the webhook ingress
    modules.services.infrastructure.cloudflared.ingress = mkIf cfg.webhook.expose (
      lib.my.mkCloudflaredIngress cfg.webhook.subdomain cfg.port
    );

    virtualisation.oci-containers.containers.reviewbot = {
      image = "ghcr.io/iostpa/reviewbot:latest";
      ports = singleton "127.0.0.1:${toString cfg.port}:3000";
      volumes = [
        "/var/lib/reviewbot:/app/data"
        "${config.modules.security.sops.secrets.reviewbot-private-key.path}:/app/data/private-key.pem:ro"
      ];
      environment = {
        NODE_ENV = "production";
        PORT = "3000";
        PRIVATE_KEY_PATH = "./data/private-key.pem";
        DB_PATH = "./data/reviewbot.db";
      }
      // cfg.config;
      environmentFiles = singleton config.modules.security.sops.secrets.reviewbot-env.path;
    };
  };
}
