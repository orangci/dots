{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    optionals
    singleton
    ;
  cfg = config.modules.server.duckdns;
in
{
  options.modules.server.duckdns = {
    enable = mkEnableOption "Enable duckdns";
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.duckdns-token.path = "/var/secrets/duckdns-token";
    networking.firewall.allowedTCPPorts =
      [ ]
      ++ (optionals config.modules.server.minecraft.juniper-s10.enable [
        config.modules.server.minecraft.juniper-s10.port # minecraft server itself
        (config.modules.server.minecraft.juniper-s10.port - 3000) # polymer autohost
      ])
      ++ (optionals config.modules.server.caddy.enable [
        80
        443
      ]);
    networking.firewall.allowedUDPPorts =
      [ ]
      ++ (optionals config.modules.server.minecraft.juniper-s10.enable [
        config.modules.server.minecraft.juniper-s10.port # UDP port for simple voice chat
      ]);
    services.duckdns = {
      enable = true;
      tokenFile = config.modules.common.sops.secrets.duckdns-token.path;
      domains = singleton "orangc";
    };
  };
}
