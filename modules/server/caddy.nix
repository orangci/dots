{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mapAttrs'
    nameValuePair
    filterAttrs
    mkMerge
    mkForce
    mkDefault
    ;

  cfg = config.modules.server.caddy;

  allModules = config.modules.server or { };
  validModules = filterAttrs (
    _: mod: mod ? domain && mod.domain != null && mod ? port && mod.port != null
  ) allModules;

  dynamicVhosts = mapAttrs' (
    _: mod:
    nameValuePair mod.domain {
      extraConfig = mkDefault ''reverse_proxy localhost:${toString mod.port}'';
      # logFormat = mkForce ''output discard''; # if you don't want logs
    }
  ) validModules;

in
{
  options.modules.server.caddy.enable = mkEnableOption "Enable Caddy";

  config = mkIf cfg.enable {
    services.caddy = {
      enable = true;
      email = "c@orangc.net";
      virtualHosts = mkMerge [
        {
          "ping.localhost".extraConfig = ''respond pong'';
          "dns.localhost".extraConfig = ''reverse_proxy 127.0.0.1:5380'';
          "mc-map.orangc.net".extraConfig =
            mkIf config.modules.server.minecraft.juniper-s10.enable ''reverse_proxy localhost:${
              toString (config.modules.server.minecraft.juniper-s10.port - 2000)
            }'';
          "mc-resourcepack.orangc.net".extraConfig =
            mkIf config.modules.server.minecraft.juniper-s10.enable ''reverse_proxy localhost:${
              toString (config.modules.server.minecraft.juniper-s10.port - 3000)
            }'';
          ${config.modules.server.chibisafe.domain}.extraConfig = ''
            route {
              @api path /api/*
              reverse_proxy @api http://localhost:${toString (config.modules.server.chibisafe.port - 1000)} {
                header_up Host {http.reverse_proxy.upstream.hostport}
                header_up X-Real-IP {http.request.header.X-Real-IP}
              }

              @docs path /docs*
              reverse_proxy @docs http://localhost:${toString (config.modules.server.chibisafe.port - 1000)} {
                header_up Host {http.reverse_proxy.upstream.hostport}
                header_up X-Real-IP {http.request.header.X-Real-IP}
              }

              reverse_proxy http://localhost:${toString config.modules.server.chibisafe.port} {
                header_up Host {http.reverse_proxy.upstream.hostport}
                header_up X-Real-IP {http.request.header.X-Real-IP}
              }

              file_server * {
                root /app/uploads
                pass_thru
              }
            }
          '';
        }
        dynamicVhosts
      ];
    };
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
