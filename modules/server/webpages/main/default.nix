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
  cfg = config.modules.server.webpages.main;
in
{
  imports = lib.singleton ./redirects.nix;
  options.modules.server.webpages.main =
    lib.my.mkServerModule {
      name = "Webpagc";
      subdomain = "";
      glanceIcon = "https://${flakeSettings.domains.primary}/leaf.png";
    }
    // {
      redirects = mkOption {
        type = types.listOf (
          types.submodule {
            options = {
              source = mkOption { type = types.str; };
              target = mkOption { type = types.str; };
              code = mkOption {
                type = types.int;
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
      ${flakeSettings.domains.primary}.extraConfig = "reverse_proxy localhost:${toString cfg.port}";
      ${flakeSettings.domains.secondary}.extraConfig = "reverse_proxy localhost:${toString cfg.port}";
      ":${toString cfg.port}".extraConfig = ''
        root * /srv/webpagc
        file_server
        header ?Cache-Control "max-age=1800"

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
        ${lib.concatStringsSep "\n" (
          map (r: "handle_path /${r.source}/* { redir ${r.target}{path} ${toString r.code} }") cfg.redirects
        )}
      '';
    };
    modules.server.cloudflared.ingress = mkIf cfg.cloudflared.enable {
      ${flakeSettings.domains.primary} = "http://localhost:${toString cfg.port}";
      ${flakeSettings.domains.secondary} = "http://localhost:${toString cfg.port}";
    };
    modules.server.glance.monitoredSites = mkIf cfg.glance.enable [
      {
        url = "https://${flakeSettings.domains.primary}";
        title = cfg.name;
        icon = cfg.glance.icon;
      }
    ];
    systemd.tmpfiles.settings."10-webpagc"."/srv/webpagc"."L+" = {
      argument = inputs.webpagc.packages.${system}.default.outPath;
      user = "root";
      mode = "0755";
    };
  };
}
