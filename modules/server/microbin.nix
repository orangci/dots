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
  options.modules.server.microbin.enable = mkEnableOption "Enable microbin";

  config = lib.mkIf cfg.enable {
    modules.common.sops.secrets.microbin.path = "/var/lib/microbin.env";
    services.microbin = {
      enable = true;
      passwordFile = "/var/lib/microbin.env";
      settings = {
        MICROBIN_HIDE_HEADER = true;
        MICROBIN_HIDE_FOOTER = true;
        MICROBIN_HIDE_LOGO = true;
        MICROBIN_PORT = 8181;
        MICROBIN_PUBLIC_PATH = "https://paste.orangc.net/";
        MICROBIN_SHORT_PATH = "https://orangc.net/";
        MICROBIN_WIDE = true;
        MICROBIN_QR = true;
        MICROBIN_DISABLE_TELEMETRY = true;
      };
    };
  };
}
