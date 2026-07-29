{
  config,
  lib,
  flakeSettings,
  ...
}:
let
  inherit (lib)
    mkIf
    singleton
    ;
  cfg = config.modules.services.webpages.fumos-net;
in
{
  options.modules.services.webpages.fumos-net = lib.my.mkServerModule {
    name = "fumos.net";
    autoConfiguredServiceInfra = false;
  };

  config = mkIf cfg.enable {
    modules.services.infrastructure = {
      caddy.virtualHosts = {
        "fumos.net".extraConfig = "reverse_proxy localhost:${toString cfg.port}";
        "www.fumos.net".extraConfig = "reverse_proxy localhost:${toString cfg.port}";
        ":${toString cfg.port}".extraConfig = ''
          root * /srv/fumos-net
          header ?Cache-Control "max-age=1800"
          file_server

          handle_errors {
            @404 expression {http.error.status_code} == 404
            redir @404 /404.html 301
          }

          @rootIndex path /index.html 
          redir @rootIndex / 301  
          @subIndex path */index.html
          redir @subIndex {path}/.. 301  
          @html path_regexp html ^(.+)\.html$  
          redir @html {re.html.1} 301 
          try_files {path} {path}.html {path}/index.html
          redir /source https://${config.modules.services.productivity.forgejo.subdomain}.${flakeSettings.domains.primary}/c/fumos.net 301
        '';
      };
      cloudflared.ingress = {
        "fumos.net" = "http://localhost:${toString cfg.port}";
        "www.fumos.net" = "http://localhost:${toString cfg.port}";
      };
    };
    modules.services.monitoring.glance.monitoredSites = singleton {
      url = "https://fumos.net";
      title = cfg.name;
      inherit (cfg.glance) icon;
    };
    systemd.tmpfiles.settings."10-webpages.fumos-net"."/srv/fumos-net"."L+" = {
      argument =
        (builtins.fetchGit {
          url = "https://git.orangc.net/c/fumos.net";
          rev = "d807d5e1e1107a2aafd0e0c3ce76e59116d42ddc";
        }).outPath;
      user = "root";
      mode = "0755";
    };
  };
}
