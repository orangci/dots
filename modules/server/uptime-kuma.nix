{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.server.uptime-kuma;
in
{
  options.modules.server.uptime-kuma = {
    enable = mkEnableOption "Enable uptime-kuma";
    port = lib.mkOption {
      type = lib.types.str;
      default = "8080";
      description = "The port for uptime kuma to listen at";
    };
  };

  config = mkIf cfg.enable {
    services.uptime-kuma = {
      enable = true;
      settings.PORT = cfg.port;
    };

    services.caddy.virtualHosts."status.orangc.net".extraConfig = ''
      reverse_proxy 127.0.0.1:${cfg.port}
    '';
  };
}
