{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.modules.server.moodle;
in
{
  options.modules.server.moodle = {
    enable = mkEnableOption "Enable moodle";

    name = mkOption {
      type = types.str;
      default = "Moodle";
    };

    port = mkOption {
      type = types.port;
      default = 8800;
      description = "The port for moodle to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "moodle.orangc.net";
      description = "The domain for moodle to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    services.moodle = {
      enable = true;
      initialPassword = "admin";
      database.port = cfg.port - 1000;
      virtualHost.listen = [
        {
          ip = "*";
          port = cfg.port;
        }
      ];
    };
  };
}
