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
  cfg = config.modules.server.immich;
in
{
  options.modules.server.immich = {
    enable = mkEnableOption "Enable immich";

    name = mkOption {
      type = types.str;
      default = "Immich";
    };

    domain = mkOption {
      type = types.str;
      default = "media.orangc.net";
      description = "The domain for immich to be hosted at";
    };
    port = mkOption {
      type = types.port;
      description = "The port for immich to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    services.immich = {
      enable = true;
      port = cfg.port;
    };
  };
}
