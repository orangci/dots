{
  config,
  lib,
  username,
  ...
}:
let
  inherit (lib) mkIf mkForce;
  cfg = config.modules.server.nixflix;
in
{
  config = mkIf cfg.enable {
    modules.server.caddy.virtualHosts = {
      "prowlarr.orangc.net".extraConfig = "reverse_proxy localhost:${toString (cfg.port + 2)}";
      "https://prowlarr.cormorant-emperor.ts.net".extraConfig = ''
        bind tailscale/prowlarr
        reverse_proxy localhost:${toString (cfg.port + 2)}
      '';
    };
    modules.common.sops.secrets = {
      "nixflix/prowlarr/apiKey".path = "/var/secrets/nixflix-prowlarr-apiKey";
      "nixflix/prowlarr/password".path = "/var/secrets/nixflix-prowlarr-password";
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
          inherit username;
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
