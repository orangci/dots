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
    modules.server.caddy.virtualHosts = {
      "radarr.${flakeSettings.domains.primary}".extraConfig =
        "reverse_proxy localhost:${toString (cfg.port + 4)}";
      "https://radarr.${flakeSettings.domains.tailnet}".extraConfig = ''
        bind tailscale/radarr
        reverse_proxy localhost:${toString (cfg.port + 4)}
      '';
    };

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
          inherit (flakeSettings) username;
          password._secret = config.modules.common.sops.secrets."nixflix/radarr/password".path;
          authenticationRequired = "disabledForLocalAddresses";
          port = mkForce (cfg.port + 4);
        };
      };
      settings.server.port = mkForce (cfg.port + 4);
    };
  };
}
