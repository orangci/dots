{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.modules.server.searxng;
in
{
  options.modules.server.searxng = {
    enable = mkEnableOption "Enable SearXNG";
    domain = lib.mkOption {
      type = lib.types.str;
      default = "https://search.orangc.net/";
      description = "The domain for SearXNG to be hosted at";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 8888;
      description = "The port for SearXNG to be hosted at";
    };
  };

  config = lib.mkIf cfg.enable {
    modules.common.sops.secrets."searx" = {
      path = "/run/secrets/searx-env";
    };

    services.searx = {
      enable = true;
      package = pkgs.searxng;
      environmentFile = "/run/secrets/searx-env";

      settings = {
        # TODO: engines configuration
        general = {
          # instance_name = "search";
          contact_url = "mailto:c@orangc.net";
        };
        search = {
          safe_search = 1;
          autocomplete = "brave";
          default_lang = "en-CA";
        };
        server = {
          base_url = cfg.domain;
          secret_key = "@SEARX_SECRET_KEY@";
          port = cfg.port;
          bind_address = "127.0.0.1";
          image_proxy = true;
          default_http_headers = {
            X-Content-Type-Options = "nosniff";
            X-XSS-Protection = "1; mode=block";
            X-Download-Options = "noopen";
            X-Robots-Tag = "noindex, nofollow";
            Referrer-Policy = "no-referrer";
          };
        };
      };
    };
    services.caddy.virtualHosts."search.orangc.net".extraConfig =
      "reverse_proxy 127.0.0.1:${toString cfg.port}";
  };
}
