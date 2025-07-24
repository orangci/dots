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

    name = mkOption {
      type = types.str;
      default = "Vaultwarden";
    };

    domain = mkOption {
      type = types.str;
      default = "vault.orangc.net";
      description = "The domain for vaultwarden to be hosted at";
    };
    port = mkOption {
      type = types.port;
      default = 8800;
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
