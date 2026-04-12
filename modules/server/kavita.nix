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
  cfg = config.modules.server.kavita;
in
{
  options.modules.server.kavita = {
    enable = mkEnableOption "Enable Kavita";

    glance.enable = mkEnableOption "Enable visibility for this service in the Glance dashboard";
    cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
    internalTailscaleDomain.enable = mkEnableOption "Enable an internal, http .home domain for this service";
    ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

    name = mkOption {
      type = types.str;
      default = "Kavita";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for kavita to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "read.${primaryDomain}";
      description = "The domain for kavita to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.kavita-token.path = "/var/secrets/kavita-token";
    services.kavita = {
      enable = true;
      settings.Port = cfg.port;
      tokenKeyFile = config.modules.common.sops.secrets.kavita-token.path;
    };
  };
}
