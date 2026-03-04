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
  };

  config = mkIf cfg.enable {
  networking.firewall.trustedInterfaces = lib.singleton "tailscale0";
    services.tailscale = {
      enable = true;
      permitCertUid = "caddy";
      useRoutingFeatures = "server";
      disableUpstreamLogging = true;
      extraUpFlags = [
        "--advertise-routes=192.168.100.0/24"
        "--advertise-exit-node"
        "--ssh"
        "--accept-dns=false"
      ];
    };
  };
}
