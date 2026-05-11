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
    modules.server.caddy.virtualHosts = my.mkCaddyEntry "radarr" (cfg.port + 4) true;
    modules.common.sops.secrets = {
      "nixflix/radarr/apiKey".path = "/var/secrets/nixflix-radarr-apiKey";
      "nixflix/radarr/password".path = "/var/secrets/nixflix-radarr-password";
    };

    modules.server.glance.monitoredSites = lib.singleton {
      url = "https://radarr.${flakeSettings.domains.tailnet}";
      title = "Radarr";
      icon = "sh:radarr";
    };

    nixflix.radarr = {
      enable = true;
      config = {
        apiKey._secret = config.modules.common.sops.secrets."nixflix/radarr/apiKey".path;
        hostConfig = {
          inherit (users.sysadmin) username;
          password._secret = config.modules.common.sops.secrets."nixflix/radarr/password".path;
          authenticationRequired = "disabledForLocalAddresses";
          port = mkForce (cfg.port + 4);
        };
      };
      settings.server.port = mkForce (cfg.port + 4);
    };
  };
}
