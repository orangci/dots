{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  cfg = config.modules.services.infrastructure.pocket-id;
in
{
  options.modules.services.infrastructure.pocket-id = lib.my.mkServerModule {
    name = "Pocket ID";
    subdomain = "id";
  };
  config = lib.mkIf cfg.enable {
    modules.security.sops.secrets."pocket-id-env".path = "/var/secrets/pocket-id-env";
    services.pocket-id = {
      enable = true;
      environmentFile = config.modules.security.sops.secrets."pocket-id-env".path;
      settings = {
        APP_URL = "https://${cfg.subdomain}.${flakeSettings.domains.primary}";
        TRUST_PROXY = true;
        PORT = cfg.port;
        ALLOW_USER_SIGNUPS = "withToken";
        VERSION_CHECK_DISABLED = true;
        UI_CONFIG_DISABLED = true;

        # SMTP config
        SMTP_HOST = "smtp.purelymail.com";
        SMTP_PORT = 587;
        SMTP_FROM = "pocket-id@${flakeSettings.domains.email}";
        SMTP_USER = "automation@${flakeSettings.domains.email}";
        SMTP_TLS = "starttls";

        # email config. if this is all off, you don't need the SMTP config
        EMAIL_LOGIN_NOTIFICATION_ENABLED = true;
        EMAIL_ONE_TIME_ACCESS_AS_ADMIN_ENABLED = true;
        EMAIL_API_KEY_EXPIRATION_ENABLED = true;
        EMAIL_VERIFICATION_ENABLED = true;

      };
    };
  };
}
