{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.modules.server.aiostreams;
in
{
  options.modules.server.aiostreams = {
    enable = mkEnableOption "Enable AIOStreams";

    glance.enable = mkEnableOption "Enable visibility for this service in the Glance dashboard";
    cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
    internalTailscaleDomain.enable = mkEnableOption "Enable an internal, http .home domain for this service";
    ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

    name = mkOption {
      type = types.str;
      default = "AIOStreams";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for AIOStreams to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "aiostreams.orangc.net";
      description = "The domain for AIOStreams to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.aiostreams-env.path = "/var/secrets/aiostreams-env";
    systemd.tmpfiles.rules = [ "d /var/lib/aiostreams 0755 root root -" ];
    virtualisation.oci-containers.containers.aiostreams = {
      image = "ghcr.io/viren070/aiostreams:latest";
      autoStart = true;
      ports = [ "${toString cfg.port}:3000" ];
      volumes = [ "/var/lib/aiostreams:/app/data" ];
      environmentFiles = [ config.modules.common.sops.secrets.aiostreams-env.path ];
      extraOptions = [
        "--name=aiostreams"
        "--restart=unless-stopped"
      ];
    };
  };
}
