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
  options.modules.server.webpages.notes = lib.my.mkServerModule {
    name = "Blog";
    subdomain = "notes";
    glanceIcon = "https://${cfg.subdomain}.${flakeSettings.domains.primary}/leaf.png";
  };

  config = mkIf cfg.enable {
    modules.server = {
      caddy.virtualHosts = {
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
          redir /source https://${config.modules.server.forgejo.subdomain}.${flakeSettings.domains.primary}/c/notes 301
          redir /analytics https://${config.modules.server.umami.subdomain}.${flakeSettings.domains.primary}/share/OuROCRqSGB6Qw0Ov/notes.orangc.net 301
          ${lib.concatStringsSep "\n" (
            map (r: "redir /${r.source} ${r.target} ${toString r.code}") cfg.redirects
          )}
        '';
      };
      cloudflared.ingress = mkIf cfg.cloudflared.enable {
        "notes.${flakeSettings.domains.primary}" = "http://localhost:${toString cfg.port}";
        "notes.${flakeSettings.domains.secondary}" = "http://localhost:${toString cfg.port}";
        "blog.${flakeSettings.domains.primary}" = "http://localhost:${toString cfg.port}";
        "blog.${flakeSettings.domains.secondary}" = "http://localhost:${toString cfg.port}";
      };
      glance.monitoredSites = mkIf cfg.glance.enable singleton {
        url = "https://${cfg.subdomain}.${flakeSettings.domains.primary}";
        title = cfg.name;
        inherit (cfg.glance) icon;
      };
    };
    systemd.tmpfiles.settings."10-webpages.notes"."/srv/notes"."L+" = {
      argument = inputs.notes-webpage.packages.${system}.default.outPath;
      user = "root";
      mode = "0755";
    };
  };
}
