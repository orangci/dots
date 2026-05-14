{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.server.microbin;
in
{
  options.modules.server.microbin = lib.my.mkServerModule {
    name = "Microbin";
    subdomain = "bin";
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets.microbin-env.path = "/var/secrets/microbin-env";
    services.microbin = {
      enable = true;
      passwordFile = "/var/secrets/microbin-env";
      settings = {
        MICROBIN_HIDE_HEADER = true;
        MICROBIN_HIDE_FOOTER = true;
        MICROBIN_HIDE_LOGO = true;
        MICROBIN_PORT = cfg.port;
        MICROBIN_PUBLIC_PATH = "https://${cfg.subdomain}.${flakeSettings.domains.primary}/";
        MICROBIN_SHORT_PATH = "https://${flakeSettings.domains.primary}/";
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
