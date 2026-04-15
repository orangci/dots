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
  cfg = config.modules.server.miniflux;
  topicsOptions = import ./ntfy/topicsOptions.nix { inherit config lib; };
in
{
  options.modules.server.miniflux = {
    enable = mkEnableOption "Enable miniflux";

    glance.enable = mkEnableOption "Enable visibility for this service in the Glance dashboard";
    cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
    internalTailscaleDomain.enable = mkEnableOption "Enable an internal, http .home domain for this service";
    ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

    name = mkOption {
      type = types.str;
      default = "MiniFlux";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for miniflux to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "miniflux.${flakeSettings.primaryDomain}";
      description = "The domain for miniflux to be hosted at";
    };

    glance.icon = mkOption {
      type = types.str;
      default = "auto-invert sh:miniflux";
      description = "The icon for Glance";
    };
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.miniflux-admin-credentials.path =
      "/var/secrets/miniflux-admin-credentials";
    services.miniflux = {
      enable = true;
      createDatabaseLocally = true;
      adminCredentialsFile = config.modules.common.sops.secrets.miniflux-admin-credentials.path;
      config = {
        CREATE_ADMIN = true;
        WATCHDOG = true;
        LISTEN_ADDR = "0.0.0.0:${toString cfg.port}";
      };
    };
    modules.server.ntfy.topics = lib.singleton {
      name = "rss";
      inherit (topicsOptions) users;
      permission = topicsOptions.permission // {
        default = "read-only";
      };
    };
  };
}
