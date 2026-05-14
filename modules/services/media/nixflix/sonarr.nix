{
  config,
  lib,
  flakeSettings,
  users,
  ...
}:
let
  inherit (lib) mkIf mkForce my;
  cfg = config.modules.services.media.nixflix;
in
{
  config = mkIf cfg.enable {
    modules.services.infrastructure.caddy.virtualHosts = my.mkCaddyEntry "sonarr" (cfg.port + 7) true;
    modules.security.sops.secrets = {
      "nixflix/sonarr/apiKey".path = "/var/secrets/nixflix-sonarr-apiKey";
      "nixflix/sonarr/password".path = "/var/secrets/nixflix-sonarr-password";
    };

    modules.services.monitoring.glance.monitoredSites = lib.singleton {
      url = "https://sonarr.${flakeSettings.domains.tailnet}";
      title = "Sonarr";
      icon = "sh:sonarr";
    };

    nixflix = {
      sonarr = {
        enable = true;
        config = {
          apiKey._secret = config.modules.security.sops.secrets."nixflix/sonarr/apiKey".path;
          hostConfig = {
            inherit (users.sysadmin) username;
            password._secret = config.modules.security.sops.secrets."nixflix/sonarr/password".path;
            authenticationRequired = "disabledForLocalAddresses";
            port = mkForce (cfg.port + 7);
          };
        };
        settings.server.port = mkForce (cfg.port + 7);
      };
    };
  };
}
