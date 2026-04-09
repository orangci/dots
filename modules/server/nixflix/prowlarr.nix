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
      };
      settings.server.port = mkForce (cfg.port + 2);
    };
  };
}
