{
  config,
  lib,
  pkgs,
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
  cfg = config.modules.server.changedetection;
in
{
  options.modules.server.changedetection = {
    enable = mkEnableOption "Enable changedetection";

    glance.enable = mkEnableOption "Enable visibility for this service in the Glance dashboard";
    cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
    internalTailscaleDomain.enable = mkEnableOption "Enable an internal, http .home domain for this service";
    ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

    name = mkOption {
      type = types.str;
      default = "ChangeDetection";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for changedetection to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "detect.${flakeSettings.domains.primary}";
      description = "The domain for changedetection to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    services.changedetection-io = {
      enable = true;
      behindProxy = true;
      port = cfg.port;
      listenAddress = "0.0.0.0";
      baseURL = "https://${cfg.domain}";
      environmentFile = pkgs.writeText "changedetection-io.env" "DISABLE_VERSION_CHECK=true";
    };
  };
}
