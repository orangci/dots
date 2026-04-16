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
  cfg = config.modules.server.linkwarden;
in
{
  options.modules.server.linkwarden = {
    enable = mkEnableOption "Enable linkwarden";

    glance.enable = mkEnableOption "Enable visibility for this service in the Glance dashboard";
    cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
    internalTailscaleDomain.enable = mkEnableOption "Enable an internal, http .home domain for this service";
    ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

    name = mkOption {
      type = types.str;
      default = "Linkwarden";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for linkwarden to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "links.${flakeSettings.primaryDomain}";
      description = "The domain for linkwarden to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.linkwarden-env.path = "/var/secrets/linkwarden-nextauth-secret";
    services.linkwarden = {
      enable = true;
      inherit (cfg) port;
      environmentFile = config.modules.common.sops.secrets.linkwarden-env.path;
      enableRegistration = false;
    };
  };
}
