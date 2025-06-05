{
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
  cfg = config.modules.server.calibre-web;
in
{
  options.modules.server.calibre-web = {
    enable = mkEnableOption "Enable calibre-web";
    domain = mkOption {
      type = types.str;
      default = "books.orangc.net";
      description = "The domain for calibre-web to be hosted at";
    };
    port = mkOption {
      type = types.int;
      default = 8802;
      description = "The port for calibre-web to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    services.caddy.virtualHosts.${cfg.domain}.extraConfig =
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
