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
        dynamicVhosts
        {
          "ping.localhost".extraConfig = ''respond pong'';
          "bin.orangc.net, localhost:80".extraConfig = ''reverse_proxy :${toString config.modules.server.microbin.port}'';
          "dns.localhost".extraConfig = ''reverse_proxy 127.0.0.1:5380'';
          "mc-map.orangc.net".extraConfig =
            mkIf config.modules.server.minecraft.juniper-s10.enable ''reverse_proxy localhost:${
              toString (config.modules.server.minecraft.juniper-s10.port - 2000)
            }'';
        }
      ];
    };
  };
}
