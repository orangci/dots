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

    port = mkOption {
      type = types.int;
      default = 8816;
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
      hostname = "chibisafe";
      dependsOn = [ "chibisafe_server" ];
      extraOptions = [ "--network=host" ];
      image = "chibisafe/chibisafe:latest";
      ports = [ "${toString cfg.port}:8001" ];
      environment.BASE_API_URL = "http://localhost:8000";
    };
    virtualisation.oci-containers.containers.chibisafe_server = {
      hostname = "chibisafe_server";
      extraOptions = [ "--network=host" ];
      image = "chibisafe/chibisafe-server:latest";
      ports = [ "${toString (cfg.port - 1000)}:8000" ];
      volumes = [
        "database:/app/database:rw"
        "uploads:/app/uploads:rw"
        "logs:/app/logs:rw"
      ];
    };
  };
}
