{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.server.cloudflared;
  sfg = modules.common.sops.secrets;
in
{
  options.modules.server.cloudflared = {
    enable = mkEnableOption "Enable Cloudflared";
  };

  config = lib.mkIf cfg.enable {
    sfg."cloudflared/cert.pem".path = "/run/secrets/cloudflared/cert.pem";
    services.cloudflared = {
      enable = true;
      tunnels.homelab = {
        certificateFile = sfg."cloudflared/cert.pem".path;
        ingress."*.orangc.net" = "http://localhost:80";
      };
    };
  };
}
