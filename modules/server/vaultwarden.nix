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
  options.modules.server.vaultwarden = {
    enable = mkEnableOption "Enable vaultwarden";
    domain = lib.mkOption {
      type = lib.types.str;
      default = "https://pass.orangc.net/";
      description = "The domain for vaultwarden to be hosted at";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 8222;
      description = "The port for vaultwarden to be hosted at";
    };
  };

  config = lib.mkIf cfg.enable {
    modules.common.sops.secrets.vaultwarden_admin_token.path = "/var/lib/vaultwarden.env";
    services.vaultwarden = {
      enable = true;
      backupDir = "/var/backup/vaultwarden";
      environmentFile = "/var/lib/vaultwarden.env";
      config = {
        domain = cfg.domain;
        signupsAllowed = false;
        rocketPort = cfg.port;
      };
    };
    services.caddy.virtualHosts."pass.orangc.net".extraConfig = ''
      reverse_proxy 127.0.0.1:${toString cfg.port}
    '';
  };
}
