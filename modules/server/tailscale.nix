{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.modules.server.tailscale;
in
{
  options.modules.server.tailscalec= {
    enable = mkEnableOption "Enable tailscale";

    name = mkOption {
      type = types.str;
      default = "Tailscale";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for tailscale  to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "ts.orangc.net";
      description = "The domain for tailscale to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    services.tailscale = {
    	enable = true;
    	permitCertUid = "caddy";
    };
  };
}
