{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.server.zipline;
in
{
  options.modules.server.zipline = lib.my.mkServerModule {
    name = "Zipline";
    subdomain = "https://cdn.jsdelivr.net/gh/selfhst/icons/png/zipline.png";
    glanceIcon = "";
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
