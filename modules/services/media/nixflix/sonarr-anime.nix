{
  config,
  lib,
  users,
  ...
}:
let
  inherit (lib) mkIf mkForce my;
  cfg = config.modules.services.media.nixflix;
in
{
  config = mkIf cfg.enable {
    modules.services.infrastructure.caddy.virtualHosts = my.mkCaddyEntry "anisonarr" (
      cfg.port + 6
    ) true;
    modules.security.sops.secrets = {
      "nixflix/sonarr-anime/apiKey".path = "/var/secrets/nixflix-sonarr-anime-apiKey";
      "nixflix/sonarr-anime/password".path = "/var/secrets/nixflix-sonarr-anime-password";
    };

    nixflix = {
      sonarr-anime = {
        enable = true;
        config = {
          apiKey._secret = config.modules.security.sops.secrets."nixflix/sonarr-anime/apiKey".path;
          hostConfig = {
            inherit (users.sysadmin) username;
            password._secret = config.modules.security.sops.secrets."nixflix/sonarr-anime/password".path;
            authenticationRequired = "disabledForLocalAddresses";
            port = mkForce (cfg.port + 6);
          };
        };
        settings.server.port = mkForce (cfg.port + 6);
      };
    };
  };
}
