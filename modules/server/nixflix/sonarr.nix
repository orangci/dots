{
  config,
  lib,
  flakeSettings,
  users,
  ...
}:
let
  inherit (lib) mkIf mkForce my;
  cfg = config.modules.server.nixflix;
in
{
  config = mkIf cfg.enable {
    modules.server.caddy.virtualHosts = my.mkCaddyEntry "sonarr" (cfg.port + 7) true;
    modules.common.sops.secrets = {
      "nixflix/sonarr/apiKey".path = "/var/secrets/nixflix-sonarr-apiKey";
      "nixflix/sonarr/password".path = "/var/secrets/nixflix-sonarr-password";
    };

    modules.server.glance.monitoredSites = lib.singleton {
      url = "https://sonarr.${flakeSettings.domains.tailnet}";
      title = "Sonarr";
      icon = "sh:sonarr";
    };

    nixflix = {
      sonarr = {
        enable = true;
        config = {
          apiKey._secret = config.modules.common.sops.secrets."nixflix/sonarr/apiKey".path;
          hostConfig = {
            inherit (users.sysadmin) username;
            password._secret = config.modules.common.sops.secrets."nixflix/sonarr/password".path;
            authenticationRequired = "disabledForLocalAddresses";
            port = mkForce (cfg.port + 7);
          };
        };
        settings.server.port = mkForce (cfg.port + 7);
      };
    };
  };
}
