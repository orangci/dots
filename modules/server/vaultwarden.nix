{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.server.vaultwarden;
in
{
  options.modules.server.vaultwarden.enable = mkEnableOption "Enable vaultwarden";

  config = lib.mkIf cfg.enable {
    modules.common.sops.secrets.vaultwarden_admin_token.path = "/var/lib/vaultwarden.env";
    services.vaultwarden = {
      enable = true;
      backupDir = "/var/backup/vaultwarden";
      environmentFile = "/var/lib/vaultwarden.env";
      config = {
        domain = "https://pass.orangc.net";
        signupsAllowed = false;
      };
    };
  };
}
