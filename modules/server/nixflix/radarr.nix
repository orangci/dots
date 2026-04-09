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
      "radarr.orangc.net".extraConfig = "reverse_proxy localhost:${toString (cfg.port + 4)}";
      "https://radarr.cormorant-emperor.ts.net".extraConfig = ''
        bind tailscale/radarr
        reverse_proxy localhost:${toString (cfg.port + 4)}
      '';
    };
    modules.common.sops.secrets = {
      "nixflix/radarr/apiKey".path = "/var/secrets/nixflix-radarr-apiKey";
      "nixflix/radarr/password".path = "/var/secrets/nixflix-radarr-password";
    };
    nixflix.radarr = {
      enable = true;
      config = {
        apiKey._secret = config.modules.common.sops.secrets."nixflix/radarr/apiKey".path;
        hostConfig = {
          inherit username;
          password._secret = config.modules.common.sops.secrets."nixflix/radarr/password".path;
          authenticationRequired = "disabledForLocalAddresses";
          port = mkForce (cfg.port + 4);
        };
      };
      settings.server.port = mkForce (cfg.port + 4);
    };
  };
}
