{
  config,
  lib,
  primaryDomain,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.modules.server.scrutiny;
in
{
  options.modules.server.scrutiny = {
    enable = mkEnableOption "Enable scrutiny";

    glance.enable = mkEnableOption "Enable visibility for this service in the Glance dashboard";
    cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
    internalTailscaleDomain.enable = mkEnableOption "Enable an internal, http .home domain for this service";
    ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

    name = mkOption {
      type = types.str;
      default = "Scrutiny";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for scrutiny to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "scrutiny.${primaryDomain}";
      description = "The domain for scrutiny to be hosted at";
    };

    glance.icon = mkOption {
      type = types.str;
      default = "auto-invert sh:scrutiny";
      description = "The icon for Glance";
    };
  };

  config = mkIf cfg.enable {
    services.smartd.enable = true;
    services.scrutiny = {
      enable = true;
      # collector.enable = true; # metrics collection
      settings.web.listen.port = cfg.port;
    };
  };
}
