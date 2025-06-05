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
    domain = mkOption {
      type = lib.types.str;
      default = "pad.orangc.net";
      description = "The domain for cryptpad to be hosted at";
    };
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
    services.caddy.virtualHosts.${cfg.domain}.extraConfig =
      "reverse_proxy 127.0.0.1:${toString cfg.port}";
  };
}
