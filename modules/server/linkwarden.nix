{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.server.linkwarden;
in
{
  options.modules.server.linkwarden = lib.my.mkServerModule {
    name = "Linkwarden";
    subdomain = "links";
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.linkwarden-env.path = "/var/secrets/linkwarden-nextauth-secret";
    services.linkwarden = {
      enable = true;
      inherit (cfg) port;
      environmentFile = config.modules.common.sops.secrets.linkwarden-env.path;
      enableRegistration = false;
    };
  };
}
