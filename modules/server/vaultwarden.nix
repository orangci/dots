{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.server.vaultwarden;
in
{
  options.modules.server.vaultwarden = {
    enable = mkEnableOption "Enable vaultwarden";
    domain = mkOption {
      type = types.str;
      default = "vault.orangc.net";
      description = "The domain for vaultwarden to be hosted at";
    };
    port = mkOption {
      type = types.int;
      default = 8813;
      description = "The port for vaultwarden to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.vaultwarden_admin_token.path = "/var/lib/vaultwarden.env";
    services.vaultwarden = {
      enable = true;
      backupDir = "/var/backup/vaultwarden";
      environmentFile = "/var/lib/vaultwarden.env";
      config = {
        domain = "https://${cfg.domain}/";
        signupsAllowed = false;
        rocketPort = cfg.port;
      };
    };
  };
}
