{ config, lib, ... }:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    types
    ;
  cfg = config.modules.server.chibisafe;
in
{
  options.modules.server.chibisafe = {
    enable = mkEnableOption "Enable chibisafe";

    name = mkOption {
      type = types.str;
      default = "Chibisafe";
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/chibi";
      description = "The directory for chibisafe data to be located at";
    };

    port = mkOption {
      type = types.port;
      description = "The port for chibisafe to be hosted at";
    };

    domain = mkOption {
      type = types.str;
      default = "safe.orangc.net";
      description = "The domain for chibisafe to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers.chibisafe = {
      image = "chibisafe/chibisafe:latest";
      ports = [ "${toString cfg.port}:8001" ];
      environment.BASE_API_URL = "http://${cfg.domain}";
    };
    virtualisation.oci-containers.containers.chibisafe_server = {
      image = "chibisafe/chibisafe-server:latest";
      ports = [ "${toString (cfg.port - 1000)}:8000" ];
      volumes = [
        "${cfg.dataDir}/database:/app/database:rw"
        "${cfg.dataDir}/logs:/app/logs:rw"
      ];
    };
  };
}
