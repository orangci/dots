{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mapAttrs'
    nameValuePair
    filterAttrs
    mkMerge
    mkDefault
    mkOption
    ;

  cfg = config.modules.server.caddy;

  allModules = config.modules.server or { };
  validModules = filterAttrs (
    _: mod: mod ? domain && mod.domain != null && mod ? port && mod.port != null
  ) allModules;

  internalTailscaleDomainModules = filterAttrs (
    _: mod:
    lib.hasAttrByPath [ "internalTailscaleDomain" "enable" ] mod && mod.internalTailscaleDomain.enable
  ) validModules;

  dynamicVhosts = lib.mkMerge [
    (mapAttrs' (
      _: mod:
      nameValuePair mod.domain { extraConfig = mkDefault "reverse_proxy localhost:${toString mod.port}"; }
    ) validModules)
    (mapAttrs' (
      _: mod:
      let
        base = lib.removeSuffix ".orangc.net" mod.domain;
      in
      nameValuePair "https://${base}.cormorant-emperor.ts.net" {
        extraConfig = mkDefault "
        bind tailscale/${base}
        reverse_proxy localhost:${toString mod.port}
        ";
      }
    ) internalTailscaleDomainModules)
  ];

in
{
  options.modules.server.caddy = {
    enable = mkEnableOption "Enable Caddy";
    virtualHosts = mkOption {
      type = types.attrsOf types.str;
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
      email = "c@orangc.net";
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
        (mkIf config.modules.server.minecraft.juniper-s10.enable {
          "mc-map.orangc.net".extraConfig =
            mkIf config.modules.server.minecraft.juniper-s10.enable "reverse_proxy localhost:${
              toString (config.modules.server.minecraft.juniper-s10.port - 2000)
            }";
        })
      ];
    };
  };
}
