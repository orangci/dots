{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib) mkIf singleton;
  cfg = config.modules.services.monitoring.wakapi;
in
{
  options.modules.services.monitoring.wakapi = lib.my.mkServerModule {
    name = "WakAPI";
    subdomain = "waka";
  };

  config = mkIf cfg.enable {
    modules.security.sops.secrets.wakapi-password-salt.path = "/var/secrets/wakapi-password-salt";
    services.wakapi = {
      enable = true;
      environmentFiles = singleton config.modules.security.sops.secrets.wakapi-password-salt.path;
      settings = {
        server = {
          inherit (cfg) port;
          public_url = "https://${cfg.subdomain}.${flakeSettings.domains.primary}";
        };
        db = {
          dialect = "sqlite3";
          name = "wakapi_db.db";
        };
        app.custom_languages = {
          "nix" = "Nix";
        };
      };
    };
  };
}
