{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    filterAttrs
    mapAttrsToList
    ;
  cfg = config.modules.server.powerdns;
  # collect enabled servers with a domain
  enabledServers = filterAttrs (_: v: v.enable && v ? domain) config.modules.server; # get tailscale ipv4
  tailscaleIP = config.services.tailscale.ipv4Address; # generate zone file content
  zoneFile = pkgs.writeText "home.zone" ''
    $TTL 1h    @   IN SOA ns.home. admin.home. (            2026030401 ; serial
     1h ; refresh      
     15m ; retry          
     30d ; expire            
     2h  ; minimum    
     )
     IN NS ns.home.  ns  IN A ${tailscaleIP}  ${
       lib.concatStringsSep "\n" (mapAttrsToList (name: _v: "${name} IN A ${tailscaleIP}") enabledServers)
     }  '';
in
{
  options.modules.server.powerdns = {
    enable = mkEnableOption "Enable PowerDNS";

    name = mkOption {
      type = types.str;
      default = "PowerDNS";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for PowerDNS to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    services.powerdns = {
      enable = true;
      extraConfig = "
      launch=bind
      bind-config=${zoneFile}
      local-address=${tailscaleIP}
      ";
    };
    networking.firewall.allowedUDPPorts = [ 53 ];
    networking.firewall.allowedTCPPorts = [ 53 ];
  };
}
