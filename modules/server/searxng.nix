{
  pkgs,
  config,
  lib,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    types
    ;
  cfg = config.modules.server.searxng;
in
{
  options.modules.server.searxng = {
    enable = mkEnableOption "Enable SearXNG";

    name = mkOption {
      type = types.str;
      default = "SearXNG";
    };

    domain = mkOption {
      type = types.str;
      default = "search.orangc.net";
      description = "The domain for SearXNG to be hosted at";
    };
    port = mkOption {
      type = types.port;
      description = "The port for SearXNG to be hosted at";
    };
  };

  config = mkIf cfg.enable {
    modules.common.sops.secrets."searx" = {
      path = "/var/secrets/searx-env";
    };

    services.searx = {
      enable = true;
      package = pkgs.searxng;
      environmentFile = "/var/secrets/searx-env";

      settings = {
        # TODO: engines configuration
        general = {
          # instance_name = "search";
          contact_url = "mailto:c@orangc.net";
        };
        search = {
          safe_search = 1;
          autocomplete = "brave";
          default_lang = "all";
        };
        server = {
          base_url = "https://${cfg.domain}/";
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
  };
}
