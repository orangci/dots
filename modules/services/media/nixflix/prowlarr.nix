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
    modules.services.infrastructure.caddy.virtualHosts = my.mkCaddyEntry "prowlarr" (cfg.port + 2) true;
    modules.security.sops.secrets = {
      "nixflix/prowlarr/apiKey".path = "/var/secrets/nixflix-prowlarr-apiKey";
      "nixflix/prowlarr/password".path = "/var/secrets/nixflix-prowlarr-password";
    };

    modules.services.monitoring.glance.monitoredSites = lib.singleton {
      url = "https://prowlarr.${flakeSettings.domains.tailnet}";
      title = "Prowlarr";
      icon = "sh:prowlarr";
    };

    nixflix.flaresolverr = {
      enable = true;
      port = cfg.port + 8;
    };
    nixflix.prowlarr = {
      enable = true;
      config = {
        apiKey._secret = config.modules.security.sops.secrets."nixflix/prowlarr/apiKey".path;
        hostConfig = {
          inherit (users.sysadmin) username;
          password._secret = config.modules.security.sops.secrets."nixflix/prowlarr/password".path;
          authenticationRequired = "disabledForLocalAddresses";
          port = mkForce (cfg.port + 2);
        };

        indexers = [
          # { name = "1337x"; }
          { name = "Nyaa.si"; }
          { name = "Bangumi Moe"; }
          { name = "nekoBT"; }
          { name = "Shana Project"; }
          { name = "The Pirate Bay"; }
          # { name = "EZTV"; }
          { name = "LimeTorrents"; }
        ];
      };
      settings.server.port = mkForce (cfg.port + 2);
    };
  };
}
