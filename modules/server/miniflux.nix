{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.server.miniflux;
  topicsOptions = import ./ntfy/topicsOptions.nix { inherit config lib; };
in
{
  options.modules.server.miniflux = lib.my.mkServerModule {
    name = "Miniflux";
    subdomain = "feed";
    glanceIcon = "auto-invert sh:miniflux";
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
