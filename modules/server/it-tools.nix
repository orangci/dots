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
      type = types.port;
      description = "The port for it-tools to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers."it-tools" = {
      image = "sharevb/it-tools:latest"; # corentinth is the original, sharevb is a guy who forked it-tools
      ports = [ "${toString cfg.port}:8080" ];
    };
  };
}
