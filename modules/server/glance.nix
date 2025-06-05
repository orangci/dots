{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    types
    mkIf
    ;
  cfg = config.modules.server.glance;
in
{
  options.modules.server.glance = {
    enable = mkEnableOption "Enable glance";
    domain = mkOption {
      type = types.str;
      default = "glance.orangc.net";
      description = "The domain for glance to be hosted at";
    };
    port = mkOption {
      type = types.int;
      default = 8806;
      description = "The port for glance to be hosted at";
    };
  };

  config = mkIf cfg.enable {
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
    services.caddy.virtualHosts.${cfg.domain}.extraConfig =
      "reverse_proxy 127.0.0.1:${toString cfg.port}";
  };
}
