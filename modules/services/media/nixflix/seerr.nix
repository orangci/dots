{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib) mkIf mkForce my;
  cfg = config.modules.services.media.nixflix;
in
{
  config = mkIf cfg.enable {
    modules.services.infrastructure.caddy.virtualHosts = my.mkCaddyEntry "seerr" (cfg.port + 5) true;
    modules.security.sops.secrets."nixflix/seerr/apiKey".path = "/var/secrets/nixflix-seerr-apiKey";

    modules.services.monitoring.glance.monitoredSites = lib.singleton {
      url = "https://seerr.${flakeSettings.domains.tailnet}";
      title = "Seerr";
      icon = "sh:seerr";
    };

    nixflix.seerr = {
      enable = true;
      apiKey._secret = config.modules.security.sops.secrets."nixflix/seerr/apiKey".path;
      port = mkForce (cfg.port + 5);
      settings.users.defaultPermissions = 1024;
    };
  };
}
