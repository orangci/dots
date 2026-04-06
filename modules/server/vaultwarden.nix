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

    glance.enable = mkEnableOption "Enable visibility for this service in the Glance dashboard";
    cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
    internalTailscaleDomain.enable = mkEnableOption "Ena   ble an internal, http .home domain for this service";
    ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

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

    glance.icon = mkOption {
      type = types.str;
      default = "auto-invert sh:vaultwarden";
      description = "The icon for Glance";
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
