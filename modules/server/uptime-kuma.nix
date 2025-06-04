{ config, lib, ... }:
let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.server.uptime-kuma;
in
{
  options.modules.server.uptime-kuma = {
    enable = mkEnableOption "Enable uptime-kuma";
    domain = lib.mkOption {
      type = lib.types.str;
      default = "status.orangc.net";
      description = "The domain for uptime kuma to be hosted at";
    };
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

    services.caddy.virtualHosts.${cfg.domain}.extraConfig = ''
      reverse_proxy 127.0.0.1:${cfg.port}
    '';
  };
}
