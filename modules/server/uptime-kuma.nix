{ config, lib, ... }:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.server.uptime-kuma;
in
{
  options.modules.server.uptime-kuma = {
    enable = mkEnableOption "Enable uptime-kuma";
    domain = mkOption {
      type = types.str;
      default = "status.orangc.net";
      description = "The domain for uptime kuma to be hosted at";
    };
    port = mkOption {
      type = types.int;
      default = 8812;
      description = "The port for uptime kuma to listen at";
    };
  };

  config = mkIf cfg.enable {
    services.uptime-kuma = {
      enable = true;
      settings.PORT = toString cfg.port;
    };
  };
}
