{
  pkgs,
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkIf
    ;
  cfg = config.modules.server.searxng;
in
{
  options.modules.server.searxng = lib.my.mkServerModule {
    name = "SearXNG";
    subdomain = "search";
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
          contact_url = "mailto:searxng@${flakeSettings.domains.email}";
        };
        search = {
          safe_search = 1;
          autocomplete = "brave";
          default_lang = "all";
        };
        server = {
          base_url = "https://${cfg.subdomain}/";
          secret_key = "@SEARX_SECRET_KEY@";
          inherit (cfg) port;
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
