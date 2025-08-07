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
  cfg = config.modules.common.networking;
in
{
  imports = [ inputs.stevenBlackHosts.nixosModule ];
  options.modules.common.networking = {
    enable = mkEnableOption "Enable networking";
  };

  config = lib.mkIf cfg.enable {
    networking = {
      networkmanager.enable = true;
      hostName = host;
      timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
      stevenBlackHosts = {
        enableIPv6 = true;
        blockFakenews = true;
        blockGambling = true;
        blockPorn = true;
      };
    };
    # dns things
    networking.nameservers = mkDefault [ "1.1.1.1" ];
    networking.firewall = {
      enable = true;
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ]; # KDE Connect
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ]; # KDE Connect
    };

    environment.systemPackages = with pkgs; [
      traceroute
      speedtest-cli
      networkmanagerapplet
      ncftp
      dig
      xh
    ];
  };
}
