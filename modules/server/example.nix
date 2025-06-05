{ config, lib, ... }:
let
  inherit (lib) mkIf mkOption mkEnableOption;
  cfg = config.modules.server.example;
in
{
  options.modules.server.example = {
    enable = mkEnableOption "Enable example";

    port = mkOption {
      type = lib.types.int;
      default = 8810;
      description = "The port for example to be hosted at";
    };

    domain = mkOption {
      type = lib.types.str;
      default = "example.orangc.net";
      description = "The domain for example to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    services.caddy.virtualHosts.${cfg.domain}.extraConfig =
      "reverse_proxy 127.0.0.1:${toString cfg.port}";
  };
}
