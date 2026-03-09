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
    ;

  cfg = config.modules.server.caddy;

  allModules = config.modules.server or { };
  validModules = filterAttrs (
    _: mod: mod ? domain && mod.domain != null && mod ? port && mod.port != null
  ) allModules;

  httpHomeModules = filterAttrs (
    _: mod: lib.hasAttrByPath [ "httpHome" "enable" ] mod && mod.httpHome.enable
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
      nameValuePair "${base}.home.orangc.net" {
        extraConfig = mkDefault ''
          reverse_proxy localhost:${toString mod.port}
          tls {
           dns cloudflare {env.CLOUDFLARE_API_TOKEN}
           resolvers 1.1.1.1 1.0.0.1 
          }
        '';
      }
    ) validModules)
    (mapAttrs' (
      _: mod:
      let
        base = lib.removeSuffix ".orangc.net" mod.domain;
      in
      nameValuePair "http://${base}.home" {
        extraConfig = mkDefault ''
          reverse_proxy localhost:${toString mod.port}
        '';
      }
    ) httpHomeModules)
  ];

in
{
  options.modules.server.caddy.enable = mkEnableOption "Enable Caddy";

  config = mkIf cfg.enable {
    modules.common.sops.secrets.acme-dns-cloudflare-token = {
      path = "/var/secrets/acme-dns-cloudflare-token";
      owner = "caddy";
    };
    services.caddy = {
      enable = true;
      email = "c@orangc.net";
      package = pkgs.caddy.withPlugins {
        plugins = [ "github.com/caddy-dns/cloudflare@v0.2.3" ];
        hash = "sha256-mmkziFzEMBcdnCWCRiT3UyWPNbINbpd3KUJ0NMW632w=";
      };
      environmentFile = config.modules.common.sops.secrets.acme-dns-cloudflare-token.path;
      globalConfig = ''
        acme_dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      '';
      virtualHosts = mkMerge [
        dynamicVhosts
        {
          "home.orangc.net".extraConfig =
            "
          tls {
           dns cloudflare {env.CLOUDFLARE_API_TOKEN}
           resolvers 1.1.1.1 1.0.0.1
           }
          ";
          "dns.orangc.net".extraConfig = "reverse_proxy 127.0.0.1:5380";
          "mc-map.orangc.net".extraConfig =
            mkIf config.modules.server.minecraft.juniper-s10.enable "reverse_proxy localhost:${
              toString (config.modules.server.minecraft.juniper-s10.port - 2000)
            }";
        }
      ];
    };
  };
}
