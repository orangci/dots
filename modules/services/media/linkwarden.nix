{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.services.media.linkwarden;
in
{
  options.modules.services.media.linkwarden = lib.my.mkServerModule {
    name = "Linkwarden";
    subdomain = "links";
  };

  config = mkIf cfg.enable {
    modules.security.sops.secrets.linkwarden-env.path = "/var/secrets/linkwarden-nextauth-secret";
    services.linkwarden = {
      enable = true;
      inherit (cfg) port;
      environmentFile = config.modules.security.sops.secrets.linkwarden-env.path;
      enableRegistration = false;
    };
  };
}
