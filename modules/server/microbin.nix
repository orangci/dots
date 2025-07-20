{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.server.microbin;
in
{
  options.modules.server.microbin = {
    enable = mkEnableOption "Enable microbin";

    name = mkOption {
      type = types.str;
      default = "Microbin";
    };

    domain = mkOption {
      type = types.str;
      default = "bin.orangc.net";
      description = "The domain for microbin to be hosted at";
    };
    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for microbin to be hosted at";
    };
  };

  config = mkIf cfg.enable {
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
        MICROBIN_HIGHLIGHTSYNTAX = true;
        MICROBIN_PRIVATE = true;
        MICROBIN_EDITABLE = true;
        MICROBIN_DISABLE_TELEMETRY = true;
      };
    };
  };
}
