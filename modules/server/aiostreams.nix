{
  config,
  lib,
  pkgs,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    singleton
    ;
  cfg = config.modules.server.aiostreams;
  envFile = pkgs.writeText "aiostreams.env" ''
    # BASE_URL=https://${cfg.domain}
    BASE_URL=https://aiostreams.cormorant-emperor.ts.ne
    ADDON_ID=${cfg.domain}
    LOG_TIMEZONE=${config.time.timeZone}
  '';
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
      default = "aiostreams.${flakeSettings.domains.primary}";
      description = "The domain for AIOStreams to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.aiostreams-secret-env.path = "/var/secrets/aiostreams-secret-env";
    systemd.tmpfiles.rules = singleton "d /var/lib/aiostreams 0755 root root -";
    virtualisation.oci-containers.containers.aiostreams = {
      image = "ghcr.io/viren070/aiostreams:latest";
      ports = singleton "${toString cfg.port}:3000";
      volumes = singleton "/var/lib/aiostreams:/app/data";
      environmentFiles = [
        config.modules.common.sops.secrets.aiostreams-secret-env.path
        envFile
      ];
    };
  };
}
