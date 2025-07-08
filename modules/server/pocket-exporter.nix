{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.modules.server.pocket-exporter;
in
{
  options.modules.server.pocket-exporter = {
    enable = mkEnableOption "Enable pocket-exporter";

    name = mkOption {
      type = types.str;
      default = "pocket-exporter";
    };

    port = mkOption {
      type = types.port;
      description = "The port for pocket-exporter to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "pocket-exporter.orangc.net";
      description = "The domain for pocket-exporter to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    #
  };
}
