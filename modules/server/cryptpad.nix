{
  config,
  pkgs,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkIf
    singleton
    ;
  cfg = config.modules.server.cryptpad;
  applicationConfig = pkgs.writeText "cryptpad-application-config.js" ''
    (() => {
    const factory = (AppConfig) => {
        // To block unregistered users from creating or saving new documents
        // Documents can still be shared with unregistered users, 
        // allowing them to edit and view files via shared links 
        AppConfig.disableAnonymousPadCreation = true;
        AppConfig.disableAnonymousStore = true;

        AppConfig.defaultDarkTheme = 'true';

        return AppConfig;
    };


    // Do not change code below
    if (typeof(module) !== 'undefined' && module.exports) {
        module.exports = factory(
            require('../www/common/application_config_internal.js')
        );
    } else if ((typeof(define) !== 'undefined' && define !== null) && (define.amd !== null)) {
        define(['/common/application_config_internal.js'], factory);
    }

    })();
  '';
in
{
  options.modules.server.cryptpad = lib.my.mkServerModule {
    name = "Cryptpad";
    subdomain = "pad";
  };

  config = mkIf cfg.enable {
    services.cryptpad = {
      enable = true;
      settings = {
        httpPort = cfg.port;
        websocketPort = cfg.port - 1000;
        httpUnsafeOrigin = "https://${cfg.subdomain}";
        httpSafeOrigin = "https://${cfg.subdomain}";
        blockDailyCheck = true; # disable telemetry
        adminKeys = singleton "[orangc@pad.${flakeSettings.domains.primary}/QHUG+vZKoGOEUVFethXDVhpWIX4NlJytiG1Sy-A2MPQ=]";
        disableIntegratedEviction = true;
      };
    };
    systemd.tmpfiles.rules = singleton "f /var/lib/cryptpad/customize/application_config.js 0644 root root - ${applicationConfig}";
  };
}
