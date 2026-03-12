{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.modules.server.zipline;
in
{
  options.modules.server.zipline = {
    enable = mkEnableOption "Enable zipline";

    glance.enable = mkEnableOption "Enable visibility for this service in the Glance dashboard";
    cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
    internalTailscaleDomain.enable = mkEnableOption "Enable an internal, http .home domain for this service";
    ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

    name = mkOption {
      type = types.str;
      default = "Zipline";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for zipline to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "zip.orangc.net";
      description = "The domain for zipline to be hosted at";
    };

    glance.icon = mkOption {
      type = types.str;
      default = "https://cdn.jsdelivr.net/gh/selfhst/icons/png/zipline.png";
      description = "The icon for Glance";
    };
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.zipline-core-secret.path = "/var/secrets/zipline-core-secret";
    services.zipline = {
      enable = true;
      environmentFiles = lib.singleton config.modules.common.sops.secrets.zipline-core-secret.path;
      settings.CORE_PORT = cfg.port;
    };
  };
}
