{
  config,
  lib,
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
    modules.server.cloudflared.ingress."http://seerr.${primaryDomain}" =
      "localhost:${toString (cfg.port + 5)}";
    modules.server.caddy.virtualHosts = {
      "seerr.${primaryDomain}".extraConfig = "reverse_proxy localhost:${toString (cfg.port + 5)}";
      "https://seerr.${tailnetName}".extraConfig = ''
        bind tailscale/seerr
        reverse_proxy localhost:${toString (cfg.port + 5)}
      '';
    };
    modules.common.sops.secrets."nixflix/seerr/apiKey".path = "/var/secrets/nixflix-seerr-apiKey";
    nixflix.seerr = {
      enable = true;
      apiKey._secret = config.modules.common.sops.secrets."nixflix/seerr/apiKey".path;
      port = mkForce (cfg.port + 5);
      settings.users.defaultPermissions = 1024;
    };
  };
}
