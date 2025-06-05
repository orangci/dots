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
    domain = mkOption {
      type = types.str;
      default = "pad.orangc.net";
      description = "The domain for cryptpad to be hosted at";
    };
    port = mkOption {
      type = types.int;
      default = 8804;
      description = "The port for cryptpad to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    services.cryptpad = {
      enable = true;
      settings.httpPort = cfg.port;
    };
    services.caddy.virtualHosts.${cfg.domain}.extraConfig =
      "reverse_proxy 127.0.0.1:${toString cfg.port}";
  };
}
