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
    modules.services.infrastructure.caddy.virtualHosts = my.mkCaddyEntry "radarr" (cfg.port + 4) true;
    modules.security.sops.secrets = {
      "nixflix/radarr/apiKey".path = "/var/secrets/nixflix-radarr-apiKey";
      "nixflix/radarr/password".path = "/var/secrets/nixflix-radarr-password";
    };

    modules.services.monitoring.glance.monitoredSites = lib.singleton {
      url = "https://radarr.${flakeSettings.domains.tailnet}";
      title = "Radarr";
      icon = "sh:radarr";
    };

    nixflix.radarr = {
      enable = true;
      config = {
        apiKey._secret = config.modules.security.sops.secrets."nixflix/radarr/apiKey".path;
        hostConfig = {
          inherit (users.sysadmin) username;
          password._secret = config.modules.security.sops.secrets."nixflix/radarr/password".path;
          authenticationRequired = "disabledForLocalAddresses";
          port = mkForce (cfg.port + 4);
        };
      };
      settings.server.port = mkForce (cfg.port + 4);
    };
  };
}
