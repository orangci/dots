{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.modules.server.speedtest;
in
{
  options.modules.server.speedtest = {
    enable = mkEnableOption "Enable speedtest-tracker";

    name = mkOption {
      type = types.str;
      default = "Speedtest Tracker";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for speedtest to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "speedtest.orangc.net";
      description = "The domain for speedtest to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.speedtest-app-key.path = "/var/secrets/speedtest-app-key";
    systemd.tmpfiles.rules = [ "d /var/lib/speedtest-tracker 0755 root root" ];
    virtualisation.oci-containers.containers.speedtest-tracker = {
      image = "lscr.io/linuxserver/speedtest-tracker:latest";
      volumes = [ "/var/lib/speedtest-tracker:/config" ];
      ports = [ "${toString cfg.port}:80" ];
      environmentFiles = [ "/var/secrets/speedtest-app-key" ];
      environment = {
        PUID = "1000";
        PGID = "1000";
        DB_CONNECTION = "sqlite";
        APP_NAME = "Speedtest";
        APP_URL = "https://${cfg.domain}";
        ASSET_URL = "https://${cfg.domain}";
        APP_TIMEZONE = config.time.timeZone;
        CHART_DATETIME_FORMAT = "m/j G.i";
        DATETIME_FORMAT = "j M Y, G.i.s";
        DISPLAY_TIMEZONE = config.time.timeZone;
        PUBLIC_DASHBOARD = "true";
        SPEEDTEST_SCHEDULE = "0 * * * *";
        SPEEDTEST_SERVERS = "26065,24115";
      };
    };
  };
}
