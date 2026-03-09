{ config, lib, ... }:
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
    httpHome.enable = mkEnableOption "Enable an internal, http .home domain for this service";
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
      default = "example.orangc.net";
      description = "The domain for example to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    #
  };
}
