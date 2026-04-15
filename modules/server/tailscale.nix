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
  cfg = config.modules.server.tailscale;

  validModules = lib.filterAttrs (
    _: mod: mod ? domain && mod.domain != null && mod ? port && mod.port != null
  ) (config.modules.server or { });

  internalTailscaleDomainModules = lib.filterAttrs (
    _: mod:
    lib.hasAttrByPath [ "internalTailscaleDomain" "enable" ] mod && mod.internalTailscaleDomain.enable
  ) validModules;

  tailscaleVhosts = lib.mapAttrs' (
    _: mod:
    let
      base = lib.removeSuffix "." (lib.removeSuffix flakeSettings.primaryDomain mod.domain);
    in
    lib.nameValuePair "https://${base}.${flakeSettings.tailnetName}" {
      extraConfig = lib.mkDefault ''
        bind tailscale/${base}
        reverse_proxy localhost:${toString mod.port}
      '';
    }
  ) internalTailscaleDomainModules;
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
    modules.server.caddy.virtualHosts = tailscaleVhosts;
    networking.firewall.trustedInterfaces = lib.singleton "tailscale0";
    systemd.services.tailscaled.before = mkIf config.modules.server.caddy.enable [
      "caddy.service"
    ];
    services.tailscale = {
      enable = true;
      permitCertUid = "caddy";
      useRoutingFeatures = "server";
      disableUpstreamLogging = true;
      extraUpFlags = [
        "--advertise-routes=192.168.100.0/24"
        "--advertise-exit-node"
        "--accept-dns"
        "--ssh=false"
      ];
      extraSetFlags = [
        "--advertise-routes=192.168.100.0/24"
        "--advertise-exit-node"
        "--accept-dns"
        "--ssh=false"
      ];
    };
  };
}
