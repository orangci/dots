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
  cfg = config.modules.services.infrastructure.tailscale;
  flags = [
    "--advertise-routes=192.168.100.0/24"
    "--advertise-exit-node"
    "--accept-dns"
    "--ssh=false"
  ];

  validModules = lib.concatMapAttrs (
    _: v:
    lib.filterAttrs (
      _: mod:
      mod.enable or false
      && mod.autoConfiguredServiceInfra or false
      && mod.internalTailscaleDomain.enable or false
    ) v
  ) config.modules.services;

  tailscaleVhosts = lib.mapAttrs' (
    _: mod:
    lib.nameValuePair "https://${mod.subdomain}.${flakeSettings.domains.tailnet}" {
      extraConfig = lib.mkDefault ''
        bind tailscale/${mod.subdomain}
        reverse_proxy localhost:${toString mod.port}
      '';
    }
  ) validModules;
in
{
  options.modules.services.infrastructure.tailscale = {
    enable = mkEnableOption "tailscale";
    name = mkOption {
      type = types.str;
      default = "Tailscale";
      description = "The display name of Tailscale, mirroring the `name` option of server modules.";
    };
  };

  config = mkIf cfg.enable {
    modules.services.infrastructure.caddy.virtualHosts = tailscaleVhosts;
    networking.firewall.trustedInterfaces = lib.singleton "tailscale0";
    services.tailscale = {
      enable = true;
      permitCertUid = "caddy";
      useRoutingFeatures = "server";
      disableUpstreamLogging = true;
      # `up` flags are used when logging in, `set` flags on every start after that
      extraUpFlags = flags;
      extraSetFlags = flags;
    };
  };
}
