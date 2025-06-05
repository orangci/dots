{ config, lib, ... }:

let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.modules.server.it-tools;
in
{
  options.modules.server.it-tools = {
    enable = mkEnableOption "Enable it-tools";
    port = lib.mkOption {
      type = lib.types.int;
      default = 8808;
      description = "The port for it-tools to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers."it-tools" = {
      image = "corentinth/it-tools:latest";
      ports = [ "${toString cfg.port}:80" ];
    };
    services.caddy.virtualHosts."tools.orangc.net".extraConfig =
      "reverse_proxy 127.0.0.1:${toString cfg.port}";
  };
}
