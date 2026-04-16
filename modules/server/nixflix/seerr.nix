{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib) mkIf mkForce;
  cfg = config.modules.server.nixflix;
in
{
  config = mkIf cfg.enable {
    modules.server.cloudflared.ingress."seerr.${flakeSettings.domains.primary}" =
      "http://localhost:${toString (cfg.port + 5)}";
    modules.server.caddy.virtualHosts = {
      "seerr.${flakeSettings.domains.primary}".extraConfig =
        "reverse_proxy localhost:${toString (cfg.port + 5)}";
      "https://seerr.${flakeSettings.domains.tailnet}".extraConfig = ''
        bind tailscale/seerr
        reverse_proxy localhost:${toString (cfg.port + 5)}
      '';
    };

    modules.common.sops.secrets."nixflix/seerr/apiKey".path = "/var/secrets/nixflix-seerr-apiKey";

    modules.server.glance.monitoredSites = lib.singleton {
      url = "https://seerr.${flakeSettings.domains.tailnet}";
      title = "Seerr";
      icon = "sh:seerr";
    };

    nixflix.seerr = {
      enable = true;
      apiKey._secret = config.modules.common.sops.secrets."nixflix/seerr/apiKey".path;
      port = mkForce (cfg.port + 5);
      settings.users.defaultPermissions = 1024;
    };
  };
}
