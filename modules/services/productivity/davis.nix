{
  config,
  lib,
  flakeSettings,
  users,
  ...
}:
let
  inherit (lib) mkIf singleton;
  cfg = config.modules.services.productivity.davis;
in
{
  options.modules.services.productivity.davis = lib.my.mkServerModule {
    name = "Davis";
    subdomain = "cal";
    glanceIcon = "di:davis";
  };

  config = mkIf cfg.enable {
    modules.security.sops.secrets = {
      "davis/admin-password".path = "/var/secrets/davis-admin-password";
      "davis/app-secret".path = "/var/secrets/davis-app-secret";
    };
    services.davis = {
      enable = true;
      adminLogin = users.sysadmin.username;
      hostname = "${cfg.subdomain}.${flakeSettings.domains.primary}";
      adminPasswordFile = config.modules.security.sops.secrets."davis/admin-password".path;
      appSecretFile = config.modules.security.sops.secrets."davis/app-secret".path;
      nginx.listen = singleton {
        addr = "0.0.0.0";
        inherit (cfg) port;
      };
    };
  };
}
