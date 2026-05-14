{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.services.files.zipline;
in
{
  options.modules.services.files.zipline = lib.my.mkServerModule {
    name = "Zipline";
    subdomain = "zip";
    glanceIcon = "https://cdn.jsdelivr.net/gh/selfhst/icons/png/zipline.png";
  };

  config = mkIf cfg.enable {
    modules.security.sops.secrets.zipline-core-secret.path = "/var/secrets/zipline-core-secret";
    services.zipline = {
      enable = true;
      environmentFiles = lib.singleton config.modules.security.sops.secrets.zipline-core-secret.path;
      settings.CORE_PORT = cfg.port;
    };
  };
}
