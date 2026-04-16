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

  cfg = config.modules.server.caddy;

  validModules = lib.filterAttrs (
    _: mod: mod ? domain && mod.domain != null && mod ? port && mod.port != null
  ) (config.modules.server or { });

  dynamicVhosts = lib.mapAttrs' (
    _: mod:
    lib.nameValuePair mod.domain {
      extraConfig = lib.mkDefault "reverse_proxy localhost:${toString mod.port}";
    }
  ) validModules;

in
{
  options.modules.server.caddy = {
    enable = mkEnableOption "Enable Caddy";
    virtualHosts = mkOption {
      type = types.attrsOf (
        types.submodule {
          freeformType = lib.types.attrs;
        }
      );
      default = { };
      description = "Collect virtual host entries from other modules";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.caddy.before = mkIf config.modules.server.tailscale.enable [
      "tailscaled.service"
    ];
    modules.common.sops.secrets.caddy-env = {
      path = "/var/secrets/caddy-env";
      owner = "caddy";
    };
    services.caddy = {
      enable = true;
      email = "c@${flakeSettings.domains.email}";
      package = pkgs.caddy.withPlugins {
        plugins = [
          "github.com/caddy-dns/cloudflare@v0.2.3"
          "github.com/tailscale/caddy-tailscale@v0.0.0-20260106222316-bb080c4414ac"
        ];
        hash = "sha256-u4ZRE0fAzyCWeGUHIKyxSpKM/tfbujAkLBBWxU5Ld5E=";
      };
      environmentFile = config.modules.common.sops.secrets.caddy-env.path;
      globalConfig = ''
        acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
        tailscale {
        	auth_key {env.TS_AUTHKEY}
        	ephemeral true
        }
      '';
      virtualHosts = mkMerge [
        dynamicVhosts
        cfg.virtualHosts
      ];
    };
  };
}
