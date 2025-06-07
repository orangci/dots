{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mapAttrs'
    nameValuePair
    filterAttrs
    mkMerge
    ;

  cfg = config.modules.server.caddy;

  allModules = config.modules.server or { };
  validModules = filterAttrs (
    _: mod: mod ? domain && mod.domain != null && mod ? port && mod.port != null
  ) allModules;

  dynamicVhosts = mapAttrs' (
    _: mod:
    nameValuePair mod.domain {
      extraConfig = ''reverse_proxy localhost:${toString mod.port}'';
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
        }
        dynamicVhosts
      ];
    };
    # networking.firewall.allowedTCPPorts = [ 80 443 ];
  };
}
