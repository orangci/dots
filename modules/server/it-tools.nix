{
  config,
  lib,
  flakeSettings,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.server.it-tools;
in
{
  options.modules.server.it-tools = {
    enable = mkEnableOption "Enable it-tools";

    glance.enable = mkEnableOption "Enable visibility for this service in the Glance dashboard";
    cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
    internalTailscaleDomain.enable = mkEnableOption "Enable an internal, http .home domain for this service";
    ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

    name = mkOption {
      type = types.str;
      default = "IT-Tools";
    };

    domain = mkOption {
      type = types.str;
      default = "tools.${flakeSettings.domains.primary}";
      description = "The domain for it-tools to be hosted at";
    };
    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for it-tools to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers."it-tools" = {
      image = "sharevb/it-tools:latest"; # corentinth is the original, sharevb is a guy who forked it-tools
      ports = [ "127.0.0.1:${toString cfg.port}:8080" ];
    };
  };
}
