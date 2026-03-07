{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    mkMerge
    types
    ;
  cfg = config.modules.server.tailscale;
  servers = config.modules.server;
in
{
  options.modules.server.tailscale = {
    enable = mkEnableOption "Enable tailscale";

    name = mkOption {
      type = types.str;
      default = "Tailscale";
    };
  };

  config = mkIf cfg.enable {
    # boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
    networking.firewall.trustedInterfaces = lib.singleton "tailscale0";
    services.tailscale = {
      enable = true;
      permitCertUid = "caddy";
      useRoutingFeatures = "server";
      disableUpstreamLogging = true;
      extraUpFlags = [
        "--advertise-routes=192.168.100.0/24"
        "--advertise-exit-node"
        "--accept-dns=false"
        "--ssh=false"
      ];
      extraSetFlags = [
        "--advertise-routes=192.168.100.0/24"
        "--advertise-exit-node"
        "--accept-dns=false"
        "--ssh=false"
      ];
    };
  };
}
