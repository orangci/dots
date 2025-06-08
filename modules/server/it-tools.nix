{ config, lib, ... }:

let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.server.it-tools;
in
{
  options.modules.server.it-tools = {
    enable = mkEnableOption "Enable it-tools";

    name = mkOption {
      type = types.str;
      default = "IT-Tools";
    };

    domain = mkOption {
      type = types.str;
      default = "tools.orangc.net";
      description = "The domain for it-tools to be hosted at";
    };
    port = mkOption {
      type = types.int;
      default = 8808;
      description = "The port for it-tools to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers."it-tools" = {
      image = "corentinth/it-tools:latest";
      ports = [ "${toString cfg.port}:80" ];
    };
  };
}
