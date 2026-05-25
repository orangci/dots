{
  config,
  lib,
  pkgs,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    types
    ;

  cfg = config.modules.services.infrastructure.caddy;

  validModules = lib.concatMapAttrs (
    _: v: lib.filterAttrs (_: mod: mod.autoConfiguredServiceInfra or false) v
  ) config.modules.services;

  mkVhostEntries =
    domain:
    lib.mapAttrs' (
      _: mod:
      lib.nameValuePair "${mod.subdomain}.${domain}" {
        extraConfig = lib.mkDefault "reverse_proxy localhost:${toString mod.port}";
      }
    ) validModules;

  domains = lib.filter (d: d != "" && d != null) [
    flakeSettings.domains.primary
    flakeSettings.domains.secondary
  ];

in
{
  options.modules.services.infrastructure.caddy = {
    enable = mkEnableOption "Enable Caddy";
    virtualHosts = mkOption {
      type = types.attrsOf (
        types.submodule {
          freeformType = types.attrs;
        }
      );
      default = { };
      description = "Collect virtual host entries from other modules";
    };
  };

  config = mkIf cfg.enable {
    modules.security.sops.secrets.caddy-env = {
      path = "/var/secrets/caddy-env";
      owner = "caddy";
    };
    services.caddy = {
      enable = true;
      email = "c@${flakeSettings.domains.email}";
      package = pkgs.caddy.withPlugins {
        plugins = [
          "github.com/caddy-dns/cloudflare@v0.2.4"
          "github.com/tailscale/caddy-tailscale@v0.0.0-20260106222316-bb080c4414ac"
        ];
        hash = "sha256-ufqG0y0mTInZRJZaYHoKeNBPnJtczvq3G24hgAuwk48=";
      };
      environmentFile = config.modules.security.sops.secrets.caddy-env.path;
      globalConfig = ''
        acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
        tailscale {
        	auth_key {env.TS_AUTHKEY}
        	ephemeral true
        }
      '';
      virtualHosts = mkMerge ((map mkVhostEntries domains) ++ lib.singleton cfg.virtualHosts);
    };
  };
}
