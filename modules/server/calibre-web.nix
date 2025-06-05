{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.server.calibre-web;
in
{
  options.modules.server.calibre-web = {
    enable = mkEnableOption "Enable calibre-web";
    port = lib.mkOption {
      type = lib.types.int;
      default = 8083;
      description = "The port for calibre-web to be hosted at";
    };
  };

  config = lib.mkIf cfg.enable {
    services.caddy.virtualHosts."books.orangc.net".extraConfig =
      "reverse_proxy 127.0.0.1:${toString cfg.port}";
    services.calibre-web = {
      enable = true;
      listen = {
        ip = "127.0.0.1";
        port = cfg.port;
      };
      options = {
        enableBookConversion = true;
        enableBookUploading = true;
      };
    };
  };
}
