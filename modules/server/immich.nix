{
  config,
  lib,
  primaryDomain,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.server.immich;
in
{
  options.modules.server.immich = {
    enable = mkEnableOption "Enable immich";

    glance.enable = mkEnableOption "Enable visibility for this service in the Glance dashboard";
    cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
    internalTailscaleDomain.enable = mkEnableOption "Enable an internal, http .home domain for this service";
    ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

    name = mkOption {
      type = types.str;
      default = "Immich";
    };

    domain = mkOption {
      type = types.str;
      default = "media.${primaryDomain}";
      description = "The domain for immich to be hosted at";
    };
    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for immich to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    services.immich = {
      enable = true;
      inherit (cfg) port;
    };
  };
}
