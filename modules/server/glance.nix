{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.server.glance;
in
{
  options.modules.server.glance = {
    enable = mkEnableOption "Enable glance";
    port = lib.mkOption {
      type = lib.types.int;
      default = 8806;
      description = "The port for glance to be hosted at";
    };
  };

  config = lib.mkIf cfg.enable {
    services.glance = {
      enable = true;
      settings = {
        server.port = cfg.port;
        pages = {
          # TODO: config - https://github.com/glanceapp/glance/blob/main/docs/configuration.md#pages--columns
          # also see https://search.nixos.org/options?channel=unstable&show=services.glance.settings.pages&from=0&size=50&sort=relevance&type=packages&query=services.glance.
        };
      };
    };
    services.caddy.virtualHosts."glance.orangc.net".extraConfig =
      "reverse_proxy 127.0.0.1:${toString cfg.port}";
  };
}
