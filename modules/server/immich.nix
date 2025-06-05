{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.server.immich;
in
{
  options.modules.server.immich = {
    enable = mkEnableOption "Enable immich";
    domain = mkOption {
      type = lib.types.str;
      default = "media.orangc.net";
      description = "The domain for immich to be hosted at";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 8807;
      description = "The port for immich to be hosted at";
    };
  };

  config = lib.mkIf cfg.enable {
    services.immich = {
      enable = true;
      port = cfg.port;
    };
    services.caddy.virtualHosts.${cfg.domain}.extraConfig =
      "reverse_proxy 127.0.0.1:${toString cfg.port}";
  };
}
