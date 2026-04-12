{
  config,
  lib,
  username,
  tailnetName,
  primaryDomain,
  ...
}:
let
  inherit (lib) mkIf mkForce;
  cfg = config.modules.server.nixflix;
in
{
  config = mkIf cfg.enable {
    modules.server.cloudflared.ingress."http://anisonarr.${primaryDomain}" =
      "localhost:${toString (cfg.port + 6)}";
    modules.server.caddy.virtualHosts = {
      "anisonarr.${primaryDomain}".extraConfig = "reverse_proxy localhost:${toString (cfg.port + 6)}";
      "https://anisonarr.${tailnetName}".extraConfig = ''
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
            inherit username;
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
