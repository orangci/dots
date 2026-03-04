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
  options.modules.server.tailscale = {
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
  networking.firewall.trustedInterfaces = lib.singleton "tailscale0";
    services.tailscale = {
      enable = true;
      permitCertUid = "caddy";
      useRoutingFeatures = "server";
      extraUpFlags = [
        "--advertise-routes=192.168.100.0/24"
        "--advertise-exit-node"
        "--ssh"
        "--accept-dns=false"
      ];
    };
  };
}
