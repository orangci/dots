{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.modules.server.tailscale;
  servers = config.modules.server;
  dynamicServices = lib.mapAttrs (_name: srv: {
    endpoints = {
      "tcp:${toString srv.port}" = "https://localhost:${toString srv.port}";
    };
  }) (lib.filterAttrs (_: srv: srv.enable or false && srv ? port) servers);
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
    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
    networking.firewall.trustedInterfaces = lib.singleton "tailscale0";
    services.tailscale = {
      enable = true;
      permitCertUid = "caddy";
      useRoutingFeatures = "server";
      disableUpstreamLogging = true;
      serve.enable = true;
      serve.services = dynamicServices;
      extraUpFlags = [
        "--advertise-routes=192.168.100.0/24"
        "--advertise-exit-node"
        "--ssh"
        "--accept-dns=false"
      ];
    };
  };
}
