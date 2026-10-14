{
  pkgs,
  config,
  host,
  lib,
  options,
  inputs,
  ...
}:
let
  inherit (lib) mkDefault mkEnableOption;
  cfg = config.modules.core.networking;
in
{
  imports = [ inputs.stevenBlackHosts.nixosModule ];
  options.modules.core.networking = {
    enable = mkEnableOption "networking";
  };

  config = lib.mkIf cfg.enable {
    networking = {
      networkmanager.enable = true;
      hostName = host;
      nameservers = mkDefault [ "1.1.1.1" ];
      timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
      stevenBlackHosts = {
        enableIPv6 = true;
        blockFakenews = true;
        blockGambling = true;
        blockPorn = true;
      };
      firewall = {
        enable = true;
        trustedInterfaces = lib.singleton "podman0";
      };
    };

    environment.systemPackages = with pkgs; [
      traceroute
      speedtest-cli
      networkmanagerapplet
      ncftp
      dig
      xh
      whois
    ];
  };
}
