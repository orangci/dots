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
  cfg = config.modules.server.example;
in
{
  options.modules.server.example = {
    enable = mkEnableOption "Enable example";

    glance.enable = mkEnableOption "Enable visibility for this service in the Glance dashboard";
    cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
    internalTailscaleDomain.enable = mkEnableOption "Enable an internal, http .home domain for this service";
    ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

    name = mkOption {
      type = types.str;
      default = "Example";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for example to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "example.${flakeSettings.domains.primary}";
      description = "The domain for example to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    #
  };
}
