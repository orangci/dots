{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.server.cloudflared;
in
{
  options.modules.server.cloudflared = {
    enable = mkEnableOption "Enable Cloudflared";
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets."cloudflared/cert.pem".path = "/run/secrets/cloudflared/cert.pem";
    modules.common.sops.secrets."cloudflared/credentials.json".path = "/run/secrets/cloudflared/credentials.json";

    services.cloudflared = {
      enable = true;
      tunnels.homelab = {
        default = "http_status:404";
        certificateFile = config.modules.common.sops.secrets."cloudflared/cert.pem".path;
        credentialsFile = config.modules.common.sops.secrets."cloudflared/credentials.json".path;
        ingress."*.orangc.net" = "http://localhost:80";
      };
    };
  };
}
