{
  config,
  lib,
  pkgs,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkOption
    mkIf
    types
    singleton
    ;
  cfg = config.modules.server.ntfy;
in
{
  imports = singleton ./scripts;
  options.modules.server.ntfy = lib.my.mkServerModule { name = "Ntfy"; } // {
    acl = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [
        "user:topic:perm"
        "orangc:food:write"
        "reimu:touhou:read"
        "cirno:frogs:read-write"
      ];
      description = "Access control rules for individual topics.";
    };
  };

  config = mkIf cfg.enable {
    # NTFY_AUTH_USERS='orangc:password:admin,john:password:user,cirno:password:user'
    # NTFY_AUTH_TOKENS='orangc:token,reimu:token'
    # To generate a valid token, use ntfy token generate
    # NTFY_WEB_PUSH_PRIVATE_KEY = you can get this from `ntfy webpush keys`
    # NTFY_SMTP_SENDER_PASS = ntfy user email password o.o
    modules.common.sops.secrets.ntfy-env.path = "/var/secrets/ntfy-env";
    # This secret should contain
    # NTFY_ACCESS_TOKEN=abc123
    modules.common.sops.secrets.ntfy-access-token = {
      path = "/var/secrets/ntfy-access-token";
      owner = "ntfy-sh";
    };

    services.ntfy-sh = {
      enable = true;
      environmentFile = config.modules.common.sops.secrets.ntfy-env.path;
      settings = {
        base-url = "https://${cfg.subdomain}.${flakeSettings.domains.primary}";
        auth-default-access = "deny-all";
        auth-access = ["*:up*:write-only"] ++ cfg.acl; # for unified push
        listen-http = ":${toString cfg.port}";
        behind-proxy = true;
        enable-login = true;
        upstream-base-url = "https://ntfy.sh";
        enable-metrics = false;
        log-level = "info";
        auth-file = "/var/lib/ntfy-sh/user.db";
        proxy-forwarded-header = "CF-Connecting-IP";
        # for attachments to notifications
        attachment-cache-dir = "/var/lib/ntfy-sh/attachments";
        attachment-total-size-limit = "7G";
        attachment-file-size-limit = "150m";
        attachment-expiry-duration = "12h";
        # web push stuff
        web-push-public-key = "BCTyKa4EUpYlTYjWwlb84tLc82f0tiYwdMd5BaMbsr6yuNAVS3oD3_jKavWpHzJUtl_GIgaRh4HBax6yakDUUy0";
        web-push-file = "/var/lib/ntfy-sh/webpush.db";
        web-push-email-address = "c@${flakeSettings.domains.email}";
        # for sending notifs via email
        smtp-sender-addr = "smtp.purelymail.com:587";
        smtp-sender-user = "automation@orangc.net";
        smtp-sender-from = "ntfy@orangc.net";
      };
    };
  };
}
