{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.server.vaultwarden;
in
{
  options.modules.server.vaultwarden = lib.my.mkServerModule {
    name = "Vaultwarden";
    subdomain = "vault";
    glanceIcon = "auto-invert sh:vaultwarden";
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.vaultwarden_admin_token.path = "/var/lib/vaultwarden.env";
    services.vaultwarden = {
      enable = true;
      backupDir = "/var/backup/vaultwarden";
      environmentFile = "/var/lib/vaultwarden.env";
      config = {
        domain = "https://${cfg.subdomain}.${flakeSettings.domains.primary}/";
        signupsAllowed = false;
        rocketPort = cfg.port;
      };
    };
  };
}
