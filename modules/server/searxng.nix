{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
  cfg = config.modules.server.searxng;
in {
  options.modules.server.searxng = {
    enable = mkEnableOption "Enable SearXNG";
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
          base_url = "https://search.orangc.net/";
          secret_key = "@SEARX_SECRET_KEY@";
          port = 8888;
          bind_address = "localhost";
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
  };
}
