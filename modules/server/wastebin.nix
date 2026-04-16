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
  cfg = config.modules.server.wastebin;
in
{
  options.modules.server.wastebin = {
    enable = mkEnableOption "Enable wastebin";

    glance.enable = mkEnableOption "Enable visibility for this service in the Glance dashboard";
    cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
    internalTailscaleDomain.enable = mkEnableOption "Enable an internal, http .home domain for this service";
    ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

    name = mkOption {
      type = types.str;
      default = "Wastebin";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for wastebin to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "bin.${flakeSettings.primaryDomain}";
      description = "The domain for wastebin to be hosted at";
    };
  };

  config = mkIf cfg.enable {
  modules.common.sops.secrets.wastebin-env.path = "/var/secrets/wastebin-env";
    services.wastebin = {
    	enable = true;
    	secretFile = config.modules.common.sops.secrets.wastebin-env.path;
    	settings = {
    		WASTEBIN_BASE_URL = "https://${flakeSettings.primaryDomain}";
    		WASTEBIN_ADDRESS_PORT = "0.0.0.0:${toString cfg.port}";
    		WASTEBIN_THEME = "catppuccin";
    		# WASTEBIN_PASTE_EXPIRATIONS = "";
    	};
    };
  };
}
