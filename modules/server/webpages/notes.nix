{
  config,
  lib,
  flakeSettings,
  inputs,
  system,
  ...
}:
let
  inherit (lib) mkIf mkOption types;
  cfg = config.modules.server.webpages.notes;
in
{
  options.modules.server.webpages.notes =
    lib.my.mkServerModule {
      name = "Blog";
      subdomain = "notes";
      glanceIcon = "https://${cfg.subdomain}.${flakeSettings.domains.primary}/leaf.png";
    }
    // {
      redirects = mkOption {
        type = types.listOf (
          types.submodule {
            options = {
              source = lib.mkOption { type = lib.types.str; };
              target = lib.mkOption { type = lib.types.str; };
              code = lib.mkOption {
                type = lib.types.int;
                default = 301;
              };
            };
          }
        );
        default = [ ];
      };
    };

  config = mkIf cfg.enable {
    modules.server.caddy.virtualHosts = {
      "notes.${flakeSettings.domains.primary}".extraConfig =
        "reverse_proxy localhost:${toString cfg.port}";
      "notes.${flakeSettings.domains.secondary}".extraConfig =
        "reverse_proxy localhost:${toString cfg.port}";
      "blog.${flakeSettings.domains.primary}".extraConfig =
        "reverse_proxy localhost:${toString cfg.port}";
      "blog.${flakeSettings.domains.secondary}".extraConfig =
        "reverse_proxy localhost:${toString cfg.port}";
      ":${toString cfg.port}".extraConfig = ''
        root * /srv/notes
        header ?Cache-Control "max-age=1800"
        file_server

        handle_errors {
         @404 expression {http.error.status_code} == 404
         rewrite @404 /404
         file_server
        }

        @rootIndex path /index.html 
        redir @rootIndex / 301  
        @subIndex path */index.html
        redir @subIndex {path}/.. 301  
        @html path_regexp html ^(.+)\.html$  
        redir @html {re.html.1} 301 
        try_files {path} {path}.html {path}/index.html
        ${lib.concatStringsSep "\n" (
          map (r: "redir /${r.source} ${r.target} ${toString r.code}") cfg.redirects
        )}
      '';
    };
    modules.server.cloudflared.ingress = mkIf cfg.cloudflared.enable {
      "notes.${flakeSettings.domains.primary}" = "http://localhost:${toString cfg.port}";
      "notes.${flakeSettings.domains.secondary}" = "http://localhost:${toString cfg.port}";
      "blog.${flakeSettings.domains.primary}" = "http://localhost:${toString cfg.port}";
      "blog.${flakeSettings.domains.secondary}" = "http://localhost:${toString cfg.port}";
    };
    modules.server.glance.monitoredSites = mkIf cfg.glance.enable [
      {
        url = "https://${cfg.subdomain}.${flakeSettings.domains.primary}";
        title = cfg.name;
        inherit (cfg.glance) icon;
      }
    ];
    systemd.tmpfiles.settings."10-webpages.notes"."/srv/notes"."L+" = {
      argument = inputs.notes-webpage.packages.${system}.default.outPath;
      user = "root";
      mode = "0755";
    };
    modules.server.webpages.notes.redirects = [
      {
        source = "source";
        target = "https://${config.modules.server.forgejo.subdomain}.${flakeSettings.domains.primary}/c/notes";
      }
      {
        source = "analytics";
        target = "https://${config.modules.server.forgejo.subdomain}.${flakeSettings.domains.primary}/c/notes";
      }
    ];
  };
}
