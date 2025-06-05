{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.server.cryptpad;
in
{
  options.modules.server.cryptpad = {
    enable = mkEnableOption "Enable cryptpad";
    port = lib.mkOption {
      type = lib.types.int;
      default = 8804;
      description = "The port for cryptpad to be hosted at";
    };
  };

  config = lib.mkIf cfg.enable {
    services.cryptpad = {
      enable = true;
      settings.httpPort = cfg.port;
    };
    services.caddy.virtualHosts."pad.orangc.net".extraConfig =
      "reverse_proxy 127.0.0.1:${toString cfg.port}";
  };
}
