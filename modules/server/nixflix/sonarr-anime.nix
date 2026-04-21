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
      "anisonarr.${flakeSettings.domains.primary}".extraConfig =
        "reverse_proxy localhost:${toString (cfg.port + 6)}";
      "https://anisonarr.${flakeSettings.domains.tailnet}".extraConfig = ''
        bind tailscale/anisonarr
        reverse_proxy localhost:${toString (cfg.port + 6)}
      '';
    };

    modules.common.sops.secrets = {
      "nixflix/sonarr-anime/apiKey".path = "/var/secrets/nixflix-sonarr-anime-apiKey";
      "nixflix/sonarr-anime/password".path = "/var/secrets/nixflix-sonarr-anime-password";
    };

    nixflix = {
      sonarr-anime = {
        enable = true;
        config = {
          apiKey._secret = config.modules.common.sops.secrets."nixflix/sonarr-anime/apiKey".path;
          hostConfig = {
            inherit (flakeSettings) username;
            password._secret = config.modules.common.sops.secrets."nixflix/sonarr-anime/password".path;
            authenticationRequired = "disabledForLocalAddresses";
            port = mkForce (cfg.port + 6);
          };
        };
        settings.server.port = mkForce (cfg.port + 6);
      };
    };
  };
}
