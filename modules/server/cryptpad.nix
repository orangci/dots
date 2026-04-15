{
  config,
  pkgs,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    singleton
    types
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
  options.modules.server.cryptpad = {
    enable = mkEnableOption "Enable cryptpad";

    glance.enable = mkEnableOption "Enable visibility for this service in the Glance dashboard";
    cloudflared.enable = mkEnableOption "Enable Cloudflare Tunnels for this service";
    internalTailscaleDomain.enable = mkEnableOption "Enable an internal, http .home domain for this service";
    ntfyChecking.enable = mkEnableOption "Allow Ntfy to send notifications when this service goes down";

    name = mkOption {
      type = types.str;
      default = "Cryptpad";
    };

    domain = mkOption {
      type = types.str;
      default = "pad.${flakeSettings.primaryDomain}";
      description = "The domain for cryptpad to be hosted at";
    };
    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for cryptpad to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    services.cryptpad = {
      enable = true;
      settings = {
        httpPort = cfg.port;
        websocketPort = cfg.port - 1000;
        httpUnsafeOrigin = "https://${cfg.domain}";
        httpSafeOrigin = "https://${cfg.domain}";
        blockDailyCheck = true; # disable telemetry
        adminKeys = singleton "[orangc@pad.${flakeSettings.primaryDomain}/QHUG+vZKoGOEUVFethXDVhpWIX4NlJytiG1Sy-A2MPQ=]";
        disableIntegratedEviction = true;
      };
    };
    systemd.tmpfiles.rules = singleton "f /var/lib/cryptpad/customize/application_config.js 0644 root root - ${applicationConfig}";
  };
}
