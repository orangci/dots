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
      "prowlarr.${flakeSettings.domains.primary}".extraConfig =
        "reverse_proxy localhost:${toString (cfg.port + 2)}";
      "https://prowlarr.${flakeSettings.domains.tailnet}".extraConfig = ''
        bind tailscale/prowlarr
        reverse_proxy localhost:${toString (cfg.port + 2)}
      '';
    };

    modules.common.sops.secrets = {
      "nixflix/prowlarr/apiKey".path = "/var/secrets/nixflix-prowlarr-apiKey";
      "nixflix/prowlarr/password".path = "/var/secrets/nixflix-prowlarr-password";
    };

    modules.server.glance.monitoredSites = lib.singleton {
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
        apiKey._secret = config.modules.common.sops.secrets."nixflix/prowlarr/apiKey".path;
        hostConfig = {
          inherit (flakeSettings) username;
          password._secret = config.modules.common.sops.secrets."nixflix/prowlarr/password".path;
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
