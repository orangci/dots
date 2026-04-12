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
    modules.server.cloudflared.ingress."sonarr.${primaryDomain}" =
      "http://localhost:${toString (cfg.port + 7)}";
    modules.server.caddy.virtualHosts = {
      "sonarr.${primaryDomain}".extraConfig = "reverse_proxy localhost:${toString (cfg.port + 7)}";
      "https://sonarr.${tailnetName}".extraConfig = ''
        bind tailscale/sonarr
        reverse_proxy localhost:${toString (cfg.port + 7)}
      '';
    };
    modules.common.sops.secrets = {
      "nixflix/sonarr/apiKey".path = "/var/secrets/nixflix-sonarr-apiKey";
      "nixflix/sonarr/password".path = "/var/secrets/nixflix-sonarr-password";
    };
    nixflix = {
      sonarr = {
        enable = true;
        config = {
          apiKey._secret = config.modules.common.sops.secrets."nixflix/sonarr/apiKey".path;
          hostConfig = {
            inherit username;
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
