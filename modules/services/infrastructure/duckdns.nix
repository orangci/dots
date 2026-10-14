{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkEnableOption
    optionals
    singleton
    ;
  cfg = config.modules.services.infrastructure.duckdns;
  inherit (config.modules.services.gaming.minecraft) juniper-s10 juniper-s11;
  # whichever juniper season is running, if any
  juniper =
    if juniper-s11.enable then
      juniper-s11
    else if juniper-s10.enable then
      juniper-s10
    else
      null;
in
{
  options.modules.services.infrastructure.duckdns.enable = mkEnableOption "duckdns";

  config = mkIf cfg.enable {
    modules.security.sops.secrets.duckdns-token.path = "/var/secrets/duckdns-token";
    networking.firewall.allowedTCPPorts =
      (optionals (juniper != null) [ juniper.port ]) # the minecraft server itself
      ++ (optionals juniper-s10.enable [ (juniper-s10.port - 3000) ]) # polymer autohost, season 10 only
      ++ (optionals config.modules.services.infrastructure.caddy.enable [
        80
        443
      ]);
    # simple voice chat
    networking.firewall.allowedUDPPorts = optionals (juniper != null) [ juniper.port ];
    services.duckdns = {
      enable = true;
      tokenFile = config.modules.security.sops.secrets.duckdns-token.path;
      domains = singleton "orangc";
    };
  };
}
