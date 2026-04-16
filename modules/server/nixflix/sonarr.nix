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
    modules.server.cloudflared.ingress."sonarr.${flakeSettings.domains.primary}" =
      "http://localhost:${toString (cfg.port + 7)}";
    modules.server.caddy.virtualHosts = {
      "sonarr.${flakeSettings.domains.primary}".extraConfig =
        "reverse_proxy localhost:${toString (cfg.port + 7)}";
      "https://sonarr.${flakeSettings.domains.tailnet}".extraConfig = ''
        bind tailscale/sonarr
        reverse_proxy localhost:${toString (cfg.port + 7)}
      '';
    };

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
            inherit (flakeSettings) username;
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
