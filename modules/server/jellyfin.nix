{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.modules.server.jellyfin;
in
{
  options.modules.server.jellyfin = {
    enable = mkEnableOption "Enable jellyfin";

    glance.enable = mkEnableOption "Enable visibility for this service in the Glance dashboard";
    cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
    internalTailscaleDomain.enable = mkEnableOption "Enable an internal, http .home domain for this service";
    ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

    name = mkOption {
      type = types.str;
      default = "Jellyfin";
    };

    port = mkOption {
      type = types.port;
      default = 8096;
      description = "The port for jellyfin to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "jellyfin.${flakeSettings.domains.primary}";
      description = "The domain for jellyfin to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    services.jellyfin.enable = true;
  };
}
