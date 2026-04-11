{
  config,
  lib,
  primaryDomain,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.server.microbin;
in
{
  options.modules.server.microbin = {
    enable = mkEnableOption "Enable microbin";

    glance.enable = mkEnableOption "Enable visibility for this service in the Glance dashboard";
    cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
    internalTailscaleDomain.enable = mkEnableOption "Enable an internal, http .home domain for this service";
    ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

    name = mkOption {
      type = types.str;
      default = "Microbin";
    };

    domain = mkOption {
      type = types.str;
      default = "bin.${primaryDomain}";
      description = "The domain for microbin to be hosted at";
    };
    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for microbin to be hosted at";
    };

    glance.icon = mkOption {
      type = types.str;
      default = "sh:microbin";
      description = "The icon for Glance";
    };
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.microbin.path = "/var/lib/microbin.env";
    services.microbin = {
      enable = true;
      passwordFile = "/var/lib/microbin.env";
      settings = {
        MICROBIN_HIDE_HEADER = true;
        MICROBIN_HIDE_FOOTER = true;
        MICROBIN_HIDE_LOGO = true;
        MICROBIN_PORT = cfg.port;
        MICROBIN_PUBLIC_PATH = "https://${cfg.domain}/";
        MICROBIN_SHORT_PATH = "https://${primaryDomain}/";
        MICROBIN_WIDE = true;
        MICROBIN_QR = true;
        MICROBIN_HIGHLIGHTSYNTAX = true;
        MICROBIN_PRIVATE = true;
        MICROBIN_EDITABLE = true;
        MICROBIN_DISABLE_TELEMETRY = true;
      };
    };
  };
}
