{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.server.microbin;
in
{
  options.modules.server.microbin = {
    enable = mkEnableOption "Enable microbin";
    domain = lib.mkOption {
      type = lib.types.str;
      default = "paste.orangc.net";
      description = "The domain for microbin to be hosted at";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 8809;
      description = "The port for microbin to be hosted at";
    };
  };

  config = lib.mkIf cfg.enable {
    modules.common.sops.secrets.microbin.path = "/var/lib/microbin.env";
    services.microbin = {
      enable = true;
      passwordFile = "/var/lib/microbin.env";
      settings = {
        MICROBIN_HIDE_HEADER = true;
        MICROBIN_HIDE_FOOTER = true;
        MICROBIN_HIDE_LOGO = true;
        MICROBIN_PORT = cfg.port;
        MICROBIN_PUBLIC_PATH = "https://${cfg.domain}/";
        MICROBIN_SHORT_PATH = "https://orangc.net/";
        MICROBIN_WIDE = true;
        MICROBIN_QR = true;
        MICROBIN_DISABLE_TELEMETRY = true;
      };
    };
    services.caddy.virtualHosts."${cfg.domain}".extraConfig =
      "reverse_proxy 127.0.0.1:${toString cfg.port}";
  };
}
