{
  config,
  lib,
  username,
  flakeSettings,
  ...
}:
let
  inherit (lib) mkIf singleton;
  cfg = config.modules.server.davis;
in
{
  options.modules.server.davis = lib.my.mkServerModule {
    name = "Davis";
    subdomain = "cal";
    glanceIcon = "di:davis";
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets = {
      "davis/admin-password".path = "/var/secrets/davis-admin-password";
      "davis/app-secret".path = "/var/secrets/davis-app-secret";
    };
    services.davis = {
      enable = true;
      adminLogin = flakeSettings.username;
      hostname = "${cfg.subdomain}.${flakeSettings.domains.primary}";
      adminPasswordFile = config.modules.common.sops.secrets."davis/admin-password".path;
      appSecretFile = config.modules.common.sops.secrets."davis/app-secret".path;
      nginx.listen = singleton {
        addr = "0.0.0.0";
        inherit (cfg) port;
      };
    };
  };
}
