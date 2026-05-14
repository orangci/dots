{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkEnableOption
    optionals
    singleton
    ;
  cfg = config.modules.services.infrastructure.duckdns;
in
{
  options.modules.services.infrastructure.duckdns.enable = mkEnableOption "Enable duckdns";

  config = mkIf cfg.enable {
    modules.security.sops.secrets.duckdns-token.path = "/var/secrets/duckdns-token";
    networking.firewall.allowedTCPPorts =
      (optionals config.modules.services.gaming.minecraft.juniper-s10.enable [
        config.modules.services.gaming.minecraft.juniper-s10.port # minecraft server itself
        (config.modules.services.gaming.minecraft.juniper-s10.port - 3000) # polymer autohost
      ])
      ++ (optionals config.modules.services.infrastructure.caddy.enable [
        80
        443
      ]);
    networking.firewall.allowedUDPPorts =
      optionals config.modules.services.gaming.minecraft.juniper-s10.enable
        [
          config.modules.services.gaming.minecraft.juniper-s10.port # UDP port for simple voice chat
        ];
    services.duckdns = {
      enable = true;
      tokenFile = config.modules.security.sops.secrets.duckdns-token.path;
      domains = singleton "orangc";
    };
  };
}
