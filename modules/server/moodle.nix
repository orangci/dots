{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.modules.server.moodle;
in
{
  options.modules.server.moodle = {
    enable = mkEnableOption "Enable moodle";

    glance.enable = mkEnableOption "Enable visibility for this service in the Glance dashboard";
    cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
    internalTailscaleDomain.enable = mkEnableOption "Enable an internal, http .home domain for this service";
    ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

    name = mkOption {
      type = types.str;
      default = "Moodle";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for moodle to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "moodle.${flakeSettings.primaryDomain}";
      description = "The domain for moodle to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    services.moodle = {
      enable = true;
      initialPassword = "admin";
      database.port = cfg.port - 1000;
      virtualHost.adminAddr = "moodle@orangc.net";
      virtualHost.hostName = "127.0.0.1";
      virtualHost.listen = lib.singleton {
        ip = "*";
        inherit (cfg) port;
      };
    };
  };
}
