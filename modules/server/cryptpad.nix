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
  cfg = config.modules.server.cryptpad;
in
{
  options.modules.server.cryptpad = {
    enable = mkEnableOption "Enable cryptpad";

    name = mkOption {
      type = types.str;
      default = "Cryptpad";
    };

    domain = mkOption {
      type = types.str;
      default = "pad.orangc.net";
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
        httpSafeOrigin = cfg.domain;
        httpUnsafeOrigin = "https://${cfg.domain}/";
        logToStdout = false;
      };
    };
  };
}
